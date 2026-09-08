variable "project_name" {
  type    = string
  default = "sandbox"
}

variable "environment" {
  type = string
}

variable "waf_rules" {
  description = "Map of WAF ACL name to its list of managed rule groups"
  type = map(list(object({
    name            = string
    override_action = string
    priority        = number
    statement_type  = string
    aws_managed_rule_group = object({
      name                            = string
      rules_action_override_to_count  = list(string)
    })
  })))

  default = {
    "alb-waf-ruleset" = [
      {
        name             = "AWSManagedRulesCommonRuleSet"
        override_action  = "none"
        priority         = 20
        statement_type   = "aws_managed_rule_group"
        aws_managed_rule_group = {
          name                            = "AWSManagedRulesCommonRuleSet"
          rules_action_override_to_count  = []
        }
      },
      {
        name             = "AWSManagedRulesSQLiRuleSet"
        override_action  = "none"
        priority         = 30
        statement_type   = "aws_managed_rule_group"
        aws_managed_rule_group = {
          name                            = "AWSManagedRulesSQLiRuleSet"
          rules_action_override_to_count  = []
        }
      },
      {
        name             = "AWSManagedRulesWindowsRuleSet"
        override_action  = "none"
        priority         = 40
        statement_type   = "aws_managed_rule_group"
        aws_managed_rule_group = {
          name                            = "AWSManagedRulesWindowsRuleSet"
          rules_action_override_to_count  = []
        }
      },
      {
        name             = "AWSManagedRulesLinuxRuleSet"
        override_action  = "none"
        priority         = 50
        statement_type   = "aws_managed_rule_group"
        aws_managed_rule_group = {
          name                            = "AWSManagedRulesLinuxRuleSet"
          rules_action_override_to_count  = []
        }
      }
    ]
  }
}
