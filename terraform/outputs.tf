output "cluster_name" {
    value = module.eks.cluster_name
}

output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "ecr_repo_url" {
  value = aws_ecr_repository.hw_webapp.repository_url
}

output "github_actions_access_key_id" {
  value = aws_iam_access_key.github_actions.id
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions.secret
  sensitive = true
}
