resource "aws_wafv2_web_acl" "alb" {
  for_each = var.waf_rules

  name        = each.key
  scope       = "REGIONAL"
  description = "WAF for ${each.key}"

  default_action {
    allow {}
  }

  dynamic "rule" {
    # dedup by rule name: a duplicate name in the list silently collapses to the last one
    for_each = { for waf_rule in each.value : waf_rule.name => waf_rule }

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
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = each.key
    sampled_requests_enabled   = true
  }
}

# NOTE: aws_wafv2_web_acl_association allows only one Web ACL per resource_arn.
# A second key in var.waf_rules would try to associate the same ALB twice and fail.
resource "aws_wafv2_web_acl_association" "alb" {
  for_each = var.waf_rules

  resource_arn = data.aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb[each.key].arn
}
