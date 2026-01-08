module "irsa_product_service" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name             = "${var.project_name}-product-service"
  allow_self_assume_role = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:product-service-sa"]
    }
  }

  role_policy_arns = {
    s3_access = aws_iam_policy.product_s3_access.arn
  }
}

resource "aws_iam_policy" "product_s3_access" {
  name        = "${var.project_name}-product-s3-access"
  path        = "/"
  description = "Allow product-service to access product images in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.product_images.arn,
          "${aws_s3_bucket.product_images.arn}/*"
        ]
      }
    ]
  })
}
