terraform {
  backend "s3" {
    bucket = "devops-project-tf-state01"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}