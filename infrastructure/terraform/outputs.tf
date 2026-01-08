output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = aws_db_instance.postgres.db_name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for product images"
  value       = aws_s3_bucket.product_images.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "ecr_repository_urls" {
  description = "URLs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

output "ecr_registry" {
  description = "ECR registry URL (without repository name)"
  value       = split("/", aws_ecr_repository.services["frontend"].repository_url)[0]
}
