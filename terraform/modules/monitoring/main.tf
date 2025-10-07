# Monitoring Module - CloudWatch, Prometheus, Grafana

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/eks/${var.cluster_name}/application"
  retention_in_days = 7

  tags = var.tags
}

# CloudWatch alarms for EKS cluster
resource "aws_cloudwatch_metric_alarm" "node_cpu" {
  count = var.enable_container_insights ? 1 : 0

  alarm_name          = "${var.cluster_name}-node-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EKS node CPU utilization"

  dimensions = {
    ClusterName = var.cluster_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "pod_cpu" {
  count = var.enable_container_insights ? 1 : 0

  alarm_name          = "${var.cluster_name}-pod-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EKS pod CPU utilization"

  dimensions = {
    ClusterName = var.cluster_name
  }

  tags = var.tags
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.cluster_name}-alerts"

  tags = var.tags
}

# Note: Prometheus and Grafana will be deployed via Helm in Kubernetes
# This is just the CloudWatch side of monitoring
