variable "aws_region" {
  description = "AWS Region to provision resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name to be used for tagging and resource naming"
  type        = string
  default     = "enterprise-gitops"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "domain_name" {
  description = "Base domain name for the platform (e.g., example.com)"
  type        = string
  default     = "example.com" # Placeholder, update this or pass via tfvars
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}
