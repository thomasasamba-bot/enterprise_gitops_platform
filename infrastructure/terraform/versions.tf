terraform {
  required_version = ">= 1.5.0"

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
  }

  # NOTE: Backend configuration will be partial or local for initial setup.
  # We recommend using S3 + DynamoDB for state locking in production.
  # backend "s3" {
  #   bucket         = "project-terraform-state"
  #   key            = "gitops-platform/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "project-terraform-lock"
  # }
}
