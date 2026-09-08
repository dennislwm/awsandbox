resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days
  tags              = merge(var.common_tags, { Name = var.name })
}
