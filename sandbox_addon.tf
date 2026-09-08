locals {
  workspace_addons = {
    sandbox = ["alb", "waf"]
  }
  enabled_addons = lookup(local.workspace_addons, terraform.workspace, [])
}

module "comprehend" {
  for_each     = toset(contains(local.enabled_addons, "comprehend") ? [terraform.workspace] : [])
  source       = "./modules/comprehend"
  project_name = local.project_name
  environment  = var.environment
}

module "alb" {
  for_each     = toset(contains(local.enabled_addons, "alb") ? [terraform.workspace] : [])
  source       = "./modules/alb"
  project_name = local.project_name
  environment  = var.environment
}

module "waf" {
  for_each     = toset(contains(local.enabled_addons, "waf") ? [terraform.workspace] : [])
  source       = "./modules/waf"
  project_name = local.project_name
  environment  = var.environment
}
