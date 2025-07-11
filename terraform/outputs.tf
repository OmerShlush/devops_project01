output "cluster_name" {
    value = module.eks.cluster_name
}

output "aws_region" {
    value = var.aws_region
}

output "ecr_repository_name" {
    value = aws_ecr_repository.hw_webapp.name
}

output "github_oidc_role_arn" {
  value = aws_iam_role.github_actions_oidc.arn
}


# output "github_actions_access_key_id" {
#   value = aws_iam_access_key.github_actions.id
# }

# output "github_actions_secret_access_key" {
#   value     = aws_iam_access_key.github_actions.secret
#   sensitive = true
# }