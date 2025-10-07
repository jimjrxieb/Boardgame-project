terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Backend configuration for state management
  backend "s3" {
    bucket         = "boardgame-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}

locals {
  # Common tags for all resources (cost tracking, ownership)
  common_tags = {
    Project     = "boardgame-platform"
    Environment = var.environment
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
    Owner       = var.owner_email
    Application = "boardgame"
    Repository  = "https://github.com/jimjrxieb/CLOUD-project"
  }

  cluster_name = "${var.project_name}-${var.environment}-eks"
}

# VPC Module - Network infrastructure
module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  tags = local.common_tags
}

# EKS Module - Kubernetes cluster
module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  cluster_version    = var.eks_cluster_version
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = var.eks_node_groups

  tags = local.common_tags
}

# RDS Module - PostgreSQL database
module "rds" {
  source = "./modules/rds"

  identifier          = "${var.project_name}-${var.environment}-db"
  engine_version      = var.rds_engine_version
  instance_class      = var.rds_instance_class
  allocated_storage   = var.rds_allocated_storage

  database_name       = var.database_name
  master_username     = var.database_username

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.database_subnet_ids
  allowed_cidr_blocks = module.vpc.private_subnet_cidrs

  backup_retention_period = var.rds_backup_retention_period

  tags = local.common_tags
}

# ALB Module - Application Load Balancer
module "alb" {
  source = "./modules/alb"

  name               = "${var.project_name}-${var.environment}"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  tags = local.common_tags
}

# Monitoring Module - CloudWatch, Prometheus, Grafana
module "monitoring" {
  source = "./modules/monitoring"

  cluster_name = module.eks.cluster_name
  environment  = var.environment

  enable_container_insights = var.enable_container_insights
  enable_prometheus         = var.enable_prometheus
  enable_grafana           = var.enable_grafana

  tags = local.common_tags
}

# Cost Optimization - Budget alerts
resource "aws_budgets_budget" "monthly_cost" {
  name              = "${var.project_name}-monthly-budget"
  budget_type       = "COST"
  limit_amount      = var.monthly_budget_limit
  limit_unit        = "USD"
  time_period_start = "2025-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_email_addresses = [var.owner_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_email_addresses = [var.owner_email]
  }

  cost_filters = {
    TagKeyValue = "user:Project$${var.project_name}"
  }
}
