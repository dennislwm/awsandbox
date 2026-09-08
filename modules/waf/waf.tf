resource "aws_wafv2_web_acl" "alb" {
  name        = local.waf_name
  scope       = "REGIONAL"
  description = "WAF for ${local.waf_name}"

  default_action {
    allow {}
  }

  dynamic "rule" {
    # dedup by rule name: a duplicate name in the list silently collapses to the last one
    for_each = { for waf_rule in var.waf_rules : waf_rule.name => waf_rule }

    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.aws_managed_rule_group.name
          vendor_name = "AWS"

          dynamic "rule_action_override" {
            for_each = rule.value.aws_managed_rule_group.rules_action_override_to_count
            content {
              name = rule_action_override.value
              action_to_use {
                count {}
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.waf_name
    sampled_requests_enabled   = false
  }

  tags = merge(var.common_tags, { Name = local.waf_name })
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "alb" {
  resource_arn            = aws_wafv2_web_acl.alb.arn
  log_destination_configs = [var.cwlog_arn]
}
