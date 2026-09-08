locals {
  waf_name = "awsandbox-waf-${var.project_name}-${var.environment}"
}

data "aws_lb" "alb" {
  name = "awsandbox-alb-${var.project_name}-${var.environment}"
}
