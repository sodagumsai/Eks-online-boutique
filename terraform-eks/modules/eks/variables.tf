variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The kubernetes version of the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "cluster_role_arn" {
  description = "The ARN of the role to be assumed by the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the role to be assumed by the EKS nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets where the EKS cluster will be deployed"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "The ID of the security group to be attached to the EKS cluster"
  type        = string
}

variable "node_sg_id" {
  description = "The ID of the security group to be attached to the EKS nodes"
  type        = string
}

variable "desired_size" {
  description = "The desired number of nodes in the EKS nodegroup"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The max number of nodes in the EKS nodegroup"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The min number of nodes in the EKS nodegroup"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "The instance types of the nodes in the EKS nodegroup"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "endpoint_private_access" {
  description = "Set to true to enable private access for the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Set to true to enable public access for the EKS cluster endpoint"
  type        = bool
  default     = true
}
