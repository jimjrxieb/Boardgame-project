variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "boardgame"
}

variable "environment" {
  description = "Environment name (production, staging, dev)"
  type        = string
  default     = "production"
}

variable "owner_email" {
  description = "Email for cost alerts and notifications"
  type        = string
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# EKS Configuration
variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "eks_node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    desired_size   = number
    min_size      = number
    max_size      = number
    instance_types = list(string)
    capacity_type  = string
  }))
  default = {
    general = {
      desired_size   = 2
      min_size      = 1
      max_size      = 4
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

# RDS Configuration
variable "rds_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "boardgame"
}

variable "database_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

# Monitoring Configuration
variable "enable_container_insights" {
  description = "Enable EKS Container Insights"
  type        = bool
  default     = true
}

variable "enable_prometheus" {
  description = "Deploy Prometheus for metrics"
  type        = bool
  default     = true
}

variable "enable_grafana" {
  description = "Deploy Grafana for dashboards"
  type        = bool
  default     = true
}

# Cost Management
variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 150
}
