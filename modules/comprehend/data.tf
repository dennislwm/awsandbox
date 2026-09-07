locals {
  subnet_a_name = "awsandbox-subnet-a-${var.project_name}-${var.environment}-01"
  subnet_b_name = "awsandbox-subnet-a-${var.project_name}-${var.environment}-02"
  domain_role_name = "awsandbox-iamrole-${var.project_name}-${var.environment}-default-exec"
  domain_sg_name = "awsandbox-sg-${var.project_name}-${var.environment}-domain"
}

data "aws_subnet" "sagemaker_subnet_a" {
  filter {
    name   = "tag:Name"
    values = [local.subnet_a_name]
  }
}

data "aws_subnet" "sagemaker_subnet_b" {
  filter {
    name   = "tag:Name"
    values = [local.subnet_b_name]
  }
}

data "aws_iam_role" "domain_role" {
  name = local.domain_role_name
}

data "aws_security_group" "domain_security_group" {
  filter {
    name   = "group-name"
    values = [local.domain_sg_name]
  }
}
