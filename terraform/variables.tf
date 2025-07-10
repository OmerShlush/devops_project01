variable "aws_region" {
    description = "AWS Region"
    default = "us-east-1"
}

variable "cluster_name" {
    type = string
    default = "devops-eks-cluster"
}