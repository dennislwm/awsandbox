variable "common_tags" {
  description = "Tags applied to every supported resource."
  type        = map(string)
  default = {
    Project     = "awsandbox"
    Environment = "dev"
    Owner       = "awsandbox"
  }
}

variable "owner" {
  description = "Naming prefix used across all resource names"
  type        = string
  default     = "awsandbox"
}

variable "aws_region" {
  description = "AWS region to provision resources in"
  type        = string
  default     = "us-east-1"
}

locals {
  project_name = terraform.workspace
}

check "workspace_not_default" {
  assert {
    condition     = terraform.workspace != "default"
    error_message = "terraform.workspace cannot be <default>; select or create a named workspace"
  }
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = can(regex("^dev$", var.environment))
    error_message = "environment can only be <dev>"
  }
}
