#!/bin/bash

set -e


echo "$GH_TOKEN" | gh auth login --with-token || {
  echo "GitHub CLI auth failed"
  exit 1
}

REPO="$1"
if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner) || {
    echo "Could not detect repository name. Please pass it as an argument."
    exit 1
  }
fi

echo "Updating secrets for repo: $REPO"

AWS_REGION=$(terraform output -raw aws_region)
CLUSTER_NAME=$(terraform output -raw cluster_name)
ECR_REPOSITORY=$(terraform output -raw ecr_repository_name)
OIDC_ROLE_ARN=$(terraform output -raw github_oidc_role_arn)

for var in AWS_REGION CLUSTER_NAME ECR_REPOSITORY OIDC_ROLE_ARN; do
  value=$(eval "echo \$$var")
  echo "Setting $var..."
  echo -n "$value" | gh secret set "$var" -R "$REPO"
done

echo "All secrets pushed successfully."
