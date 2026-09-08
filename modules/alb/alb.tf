resource "aws_lb" "alb" {
  name               = "awsandbox-alb-${var.project_name}-${var.environment}"
  internal           = true
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id]
  security_groups    = [data.aws_security_group.domain.id]
}
