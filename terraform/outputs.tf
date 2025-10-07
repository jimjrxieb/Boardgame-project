output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.vpc.database_subnet_ids
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds.database_name
}

output "rds_master_username" {
  description = "RDS master username"
  value       = module.rds.master_username
  sensitive   = true
}

output "rds_password_secret_arn" {
  description = "ARN of AWS Secrets Manager secret containing RDS password"
  value       = module.rds.password_secret_arn
  sensitive   = true
}

output "alb_dns_name" {
  description = "DNS name of Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of Application Load Balancer"
  value       = module.alb.zone_id
}

output "alb_arn" {
  description = "ARN of Application Load Balancer"
  value       = module.alb.arn
}

output "grafana_url" {
  description = "Grafana dashboard URL (if enabled)"
  value       = var.enable_grafana ? "http://${module.alb.dns_name}/grafana" : "Grafana not enabled"
}

output "prometheus_url" {
  description = "Prometheus URL (if enabled)"
  value       = var.enable_prometheus ? "http://${module.alb.dns_name}/prometheus" : "Prometheus not enabled"
}

output "application_url" {
  description = "Application URL"
  value       = "http://${module.alb.dns_name}"
}

output "cost_dashboard_link" {
  description = "AWS Cost Explorer link for this project"
  value       = "https://console.aws.amazon.com/cost-management/home#/cost-explorer?filter=%5B%7B%22dimension%22:%22Project%22,%22values%22:%5B%22${var.project_name}%22%5D%7D%5D"
}
