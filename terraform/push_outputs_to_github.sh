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
AWS_ACCESS_KEY_ID=$(terraform output -raw github_actions_access_key_id)
AWS_SECRET_ACCESS_KEY=$(terraform output -raw github_actions_secret_access_key)
for var in AWS_REGION CLUSTER_NAME ECR_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY; do
  value=$(eval "echo \$$var")
  echo "Setting $var..."
  echo -n "$value" | gh secret set "$var" -R "$REPO"
done

echo "All secrets pushed successfully."
