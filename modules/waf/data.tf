locals {
  alb_name = "awsandbox-alb-${var.project_name}-${var.environment}"
}

data "aws_lb" "alb" {
  name = local.alb_name
}
