locals {
  subnet_a_name = "${var.owner}-subnet-a-${var.project_name}-${var.environment}-01"
  subnet_b_name = "${var.owner}-subnet-a-${var.project_name}-${var.environment}-02"
  domain_sg_name = "${var.owner}-sg-${var.project_name}-${var.environment}-domain"
}

data "aws_subnet" "subnet_a" {
  filter {
    name   = "tag:Name"
    values = [local.subnet_a_name]
  }
}

data "aws_subnet" "subnet_b" {
  filter {
    name   = "tag:Name"
    values = [local.subnet_b_name]
  }
}

data "aws_security_group" "domain" {
  filter {
    name   = "group-name"
    values = [local.domain_sg_name]
  }
}
