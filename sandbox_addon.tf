locals {
  workspace_addons = {
    sandbox = []
  }
  enabled_addons       = lookup(local.workspace_addons, terraform.workspace, [])
  waf_cwlog_group_name = "aws-waf-logs-${var.owner}-${local.project_name}-${var.environment}"
}

module "cloudwatch" {
  for_each    = toset(contains(local.enabled_addons, "cloudwatch") ? [terraform.workspace] : [])
  source      = "./modules/cloudwatch"
  name        = local.waf_cwlog_group_name
  common_tags = var.common_tags
}

module "comprehend" {
  for_each     = toset(contains(local.enabled_addons, "comprehend") ? [terraform.workspace] : [])
  source       = "./modules/comprehend"
  owner        = var.owner
  project_name = local.project_name
  environment  = var.environment
}

module "alb" {
  for_each     = toset(contains(local.enabled_addons, "alb") ? [terraform.workspace] : [])
  source       = "./modules/alb"
  owner        = var.owner
  project_name = local.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "waf" {
  for_each     = toset(contains(local.enabled_addons, "waf") ? [terraform.workspace] : [])
  source       = "./modules/waf"
  owner        = var.owner
  project_name = local.project_name
  environment  = var.environment
  alb_arn      = module.alb[terraform.workspace].arn
  cwlog_arn    = module.cloudwatch[terraform.workspace].arn
  common_tags  = var.common_tags
}
