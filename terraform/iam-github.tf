# Use GitHub's OIDC provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# Allow GitHub Actions to assume the role via OIDC
data "aws_iam_policy_document" "github_ci_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    # Scope access to a specific repo and branch
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:omershlush/devops_project01:ref:refs/heads/main"]
    }
  }
}

# Your CI permissions
data "aws_iam_policy_document" "github_ci_permissions" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:CreateRepository",
    ]
    resources = ["*"]
  }

  statement {
    actions = ["eks:DescribeCluster"]
    resources = ["*"]
  }

  statement {
    actions = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "github_actions_oidc" {
  name  = "github-actions-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_ci_assume_role.json
}

resource "aws_iam_role_policy" "github_ci_policy" {
  name  = "github-ci-policy"
  role  = aws_iam_role.github_actions_oidc.id
  policy    = data.aws_iam_policy_document.github_ci_permissions.json
}

