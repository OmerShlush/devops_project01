resource "aws_iam_user" "github_actions" {
  name = "github-actions-deploy"
}

resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}

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
    actions = [
      "eks:DescribeCluster"
    ]
    resources = ["*"]
  }

  statement {
    actions = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_ci" {
  name   = "github-ci-policy"
  policy = data.aws_iam_policy_document.github_ci_permissions.json
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_ci.arn
}
