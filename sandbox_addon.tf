locals {
  workspace_addons = {
    sandbox = []
  }
  enabled_addons = lookup(local.workspace_addons, terraform.workspace, [])
}

module "comprehend" {
  for_each     = toset(contains(local.enabled_addons, "comprehend") ? [terraform.workspace] : [])
  source       = "./modules/comprehend"
  project_name = local.project_name
  environment  = var.environment
}
