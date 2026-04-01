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

# MISCONFIGURATION 1: Public S3 bucket — no block public access
resource "aws_s3_bucket" "vulnerable" {
  bucket = "securepipe-vulnerable-310544499318"
  tags = {
    Project = "SecurePipe"
    Stage   = "vulnerable"
  }
}

resource "aws_s3_bucket_public_access_block" "vulnerable" {
  bucket = aws_s3_bucket.vulnerable.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION 2: Overly permissive IAM role
resource "aws_iam_role" "vulnerable" {
  name = "securepipe-vulnerable-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "vulnerable" {
  role       = aws_iam_role.vulnerable.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# MISCONFIGURATION 3: Security group with SSH open to the world
resource "aws_security_group" "vulnerable" {
  name        = "securepipe-vulnerable-sg"
  description = "Vulnerable security group for SecurePipe demo"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# CHAOS INJECT: Hardcoded credentials (simulated secret leak)
# aws_access_key = "AKIAIOSFODNN7EXAMPLE"
# aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# CHAOS INJECT: Root account usage allowed
resource "aws_iam_role" "chaos_role" {
  name = "securepipe-chaos-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { AWS = "*" }
    }]
  })
}

# CHAOS INJECT: S3 bucket with no restrictions
resource "aws_s3_bucket" "chaos" {
  bucket = "securepipe-chaos-310544499318"
}

resource "aws_s3_bucket_public_access_block" "chaos" {
  bucket                  = aws_s3_bucket.chaos.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# CHAOS INJECT: Hardcoded credentials (simulated secret leak)
# aws_access_key = "AKIAIOSFODNN7EXAMPLE"
# aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# CHAOS INJECT: Root account usage allowed
resource "aws_iam_role" "chaos_role" {
  name = "securepipe-chaos-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { AWS = "*" }
    }]
  })
}

# CHAOS INJECT: S3 bucket with no restrictions
resource "aws_s3_bucket" "chaos" {
  bucket = "securepipe-chaos-310544499318"
}

resource "aws_s3_bucket_public_access_block" "chaos" {
  bucket                  = aws_s3_bucket.chaos.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
