terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  # Recommended: remote state in S3 + DynamoDB lock table
  # backend "s3" {
  #   bucket = "ecommerce-tfstate-bucket"
  #   key    = "prod/terraform.tfstate"
  #   region = "eu-west-1"
  #   dynamodb_table = "ecommerce-tf-lock"
  # }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" { state = "available" }
