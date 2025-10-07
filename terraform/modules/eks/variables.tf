variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS nodes"
  type        = list(string)
}

variable "node_groups" {
  description = "Node group configurations"
  type = map(object({
    desired_size   = number
    min_size      = number
    max_size      = number
    instance_types = list(string)
    capacity_type  = string
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
