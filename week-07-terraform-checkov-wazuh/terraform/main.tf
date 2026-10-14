# Training configuration: only the SSH finding has been remediated.
# Static scanning and validation only; do not apply this incomplete baseline.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "week7_vpc" {
  cidr_block           = "10.7.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "week7-iac-vpc"
    Project = "Week7-Terraform-Checkov-Wazuh"
  }
}

resource "aws_security_group" "week7_sg" {
  name        = "week7-iac-security-group"
  description = "Security group for Week 7 IaC security lab"
  vpc_id      = aws_vpc.week7_vpc.id

  ingress {
    description = "LAB TEST - Restrict SSH to lab VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.7.0.0/16"]
  }

  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "week7-iac-sg"
    Project = "Week7-Terraform-Checkov-Wazuh"
  }
}

# Deliberately incomplete S3 baseline: no lifecycle, logging, versioning,
# explicit encryption configuration, or public-access-block resources here.
resource "aws_s3_bucket" "week7_bucket" {
  bucket_prefix = "week7-iac-lab-"

  tags = {
    Name    = "week7-iac-storage"
    Project = "Week7-Terraform-Checkov-Wazuh"
  }
}
