terraform {
  required_version = ">= 0.11.2"

  backend "s3" {
    profile        = "x-personal"
    bucket         = "terraform-remote-state-reedflinch-io"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "terraform-remote-state-reedflinch-io"
  }
}

variable "region" {
  description = "AWS region to provision resources"
  type        = "string"
  default     = "us-east-1"
}

provider "aws" {
  profile             = "x-personal"
  allowed_account_ids = [143994185263]
  region              = "${var.region}"
}

variable "domain" {
  description = "DNS domain for web S3 distribution - (ex. reedflinch.io)"
  type        = "string"
  default     = "reedflinch.io"
}

variable "bucket_name" {
  description = "Name of web S3 bucket"
  type        = "string"
  default     = "reedflinch-io"
}

data "aws_acm_certificate" "web" {
  domain   = "${var.domain}"
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}
