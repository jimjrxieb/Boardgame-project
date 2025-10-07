# Terraform Infrastructure for AWS Deployment

This directory contains Terraform code to deploy the Board Game application to AWS with:
- VPC with public/private/database subnets across 3 AZs
- EKS cluster (Kubernetes) with managed node groups
- RDS PostgreSQL database with encryption
- Application Load Balancer
- CloudWatch monitoring and alarms
- Cost optimization and tagging

## Architecture

```
Internet
   ↓
Application Load Balancer (Public Subnets)
   ↓
EKS Cluster (Private Subnets)
   ├── Node Group (t3.small instances)
   └── Pods (Boardgame application)
   ↓
RDS PostgreSQL (Database Subnets)
```

## Prerequisites

1. **AWS CLI** configured with credentials
   ```bash
   aws configure
   ```

2. **Terraform** >= 1.0
   ```bash
   terraform version
   ```

3. **kubectl** for Kubernetes management
   ```bash
   kubectl version --client
   ```

## Quick Start

### 1. Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

**Required variables:**
- `owner_email` - Your email for cost alerts

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Create S3 Backend (First Time Only)

```bash
# Create S3 bucket for state
aws s3 mb s3://boardgame-terraform-state --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket boardgame-terraform-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 4. Plan Infrastructure

```bash
terraform plan
```

Review the plan carefully - this will create ~50 AWS resources.

### 5. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. **Deployment takes ~15-20 minutes** (mostly EKS cluster creation).

### 6. Configure kubectl

```bash
# Get command from Terraform output
terraform output configure_kubectl

# Run the command (example)
aws eks update-kubeconfig --region us-east-1 --name boardgame-production-eks
```

### 7. Verify Deployment

```bash
# Check nodes
kubectl get nodes

# Check namespaces
kubectl get namespaces

# Get application URL
terraform output application_url
```

## Outputs

After deployment, Terraform provides:

```bash
# View all outputs
terraform output

# Get specific values
terraform output eks_cluster_endpoint
terraform output rds_endpoint
terraform output application_url
terraform output grafana_url
```

## Cost Estimate

**Monthly costs (us-east-1):**
- EKS Control Plane: ~$73/month
- EKS Nodes (2 × t3.small): ~$30/month
- RDS (db.t3.micro): ~$12/month
- ALB: ~$16/month
- **Total: ~$131/month**

**Cost savings:**
- Use AWS Free Tier (12 months)
- Destroy when not in use: `terraform destroy`
- Use Spot instances for nodes

## Monitoring & Observability

### CloudWatch Dashboards

```bash
# View logs
aws logs tail /aws/eks/boardgame-production-eks/cluster --follow

# View metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EKS \
  --metric-name node_cpu_utilization \
  --dimensions Name=ClusterName,Value=boardgame-production-eks \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average
```

### Prometheus & Grafana

Installed via Helm after EKS is ready (see `/kubernetes/monitoring/`).

## Security Features

- ✅ Secrets encrypted with KMS (EKS + RDS)
- ✅ RDS master password in AWS Secrets Manager
- ✅ Private subnets for compute & database
- ✅ Security groups with least-privilege access
- ✅ VPC Flow Logs enabled
- ✅ EKS control plane logging enabled
- ✅ IMDSv2 required on EC2 instances
- ✅ EBS volumes encrypted

## Troubleshooting

### EKS cluster not accessible

```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name boardgame-production-eks

# Check AWS credentials
aws sts get-caller-identity
```

### RDS connection issues

```bash
# Get RDS password from Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id boardgame-production-db-master-password \
  --query SecretString --output text | jq .
```

### High costs

```bash
# Check current spend
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '1 month ago' +%Y-%m-01),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Project
```

## Cleanup

### Destroy Everything

```bash
terraform destroy
```

Type `yes` when prompted. **This deletes all resources and data.**

### Destroy Specific Resources

```bash
# Destroy just RDS (keep cluster)
terraform destroy -target=module.rds

# Destroy just EKS nodes (keep control plane)
terraform destroy -target=module.eks.aws_eks_node_group.main
```

## Modules

- `modules/vpc/` - VPC with public/private/database subnets
- `modules/eks/` - EKS cluster with managed node groups
- `modules/rds/` - PostgreSQL database with encryption
- `modules/alb/` - Application Load Balancer
- `modules/monitoring/` - CloudWatch logs and alarms

## Next Steps

After infrastructure is deployed:

1. Deploy application to EKS (see `/kubernetes/`)
2. Set up monitoring (Prometheus/Grafana)
3. Configure DNS (Route53)
4. Set up SSL/TLS (ACM + ALB listener)
5. Configure CI/CD to deploy to EKS

## Support

For issues or questions, see:
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- Project repository issues
