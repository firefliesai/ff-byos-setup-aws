terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "your access key"
  secret_key = "your secret key"
}