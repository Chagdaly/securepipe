terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "practice" {
  bucket = "securepipe-practice-310544499318"
  tags = {
    Project = "SecurePipe"
    Stage   = "practice"
  }
}