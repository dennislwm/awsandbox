# 19awsandbox

Terraform project for AWS infrastructure, validated against Floci (a local AWS emulator) before applying to real AWS.

Requires: [Terraform >= 1.9.2](https://developer.hashicorp.com/terraform/install)

## Workflow

1. `make setup` -- initializes Terraform and checks for Docker (required to run [Floci](https://floci.io), a local AWS emulator).
2. `make up` -- starts Floci in Docker (`make down` stops it).
3. `make test` -- runs `terraform test` before touching any real infrastructure.
4. `make validate` -- checks Terraform config syntax.
5. `make plan` / `make apply` -- provisions the root config: one VPC, two subnets, a security group, and an IAM role, per Terraform workspace. Each workspace is an isolated environment; `project_name` is derived from the active workspace name (`terraform.workspace`), not a variable.

   Against Floci, the AWS provider still requires credential env vars to be *set* (Floci doesn't validate them) -- `.env` already carries `AWS_ENDPOINT_URL`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `TF_WORKSPACE`, and the Makefile exports it automatically.

6. Addons (`modules/<name>/`, e.g. `modules/comprehend/`) are provisioned in the same root config and state as the VPC prerequisite. Which addons a workspace gets is controlled by `sandbox_addon.tf`'s `workspace_addons` map:

   ```hcl
   locals {
     workspace_addons = {
       sandbox = ["comprehend"]
       demo    = []
     }
   }
   ```

   Each addon module is gated with `for_each` against that list, so `sandbox` provisions the `comprehend` module alongside its VPC/subnets/SG/role in one `make apply`, while `demo` provisions the VPC only. Add an addon to a workspace by adding its name to that workspace's list; add a brand-new addon by adding a new `module` block gated the same way.

## Switching workspaces

Edit `TF_WORKSPACE` in `.env` to the target workspace name (create it first with `terraform workspace new <name>` if it doesn't exist yet). Every `make` target picks it up automatically since Terraform reads `TF_WORKSPACE` natively -- this also changes which addons `workspace_addons` enables.

**Example: two workspaces, one with an addon.**

```
terraform workspace new sandbox
make apply    # TF_WORKSPACE=sandbox in .env -> VPC + comprehend module

terraform workspace new demo
make apply    # TF_WORKSPACE=demo in .env -> VPC only, no addons
```

Each workspace has its own state file (`terraform.tfstate.d/<workspace>/terraform.tfstate`), so `demo` never touches `sandbox`'s resources.

## Maintainer setup

Create a `.env` file at the repo root (gitignored) with local config the Makefile exports to every target:

```
CONTAINER_CMD=podman
AWS_ENDPOINT_URL=http://localhost:4566
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
TF_WORKSPACE=sandbox
```

`CONTAINER_CMD` selects the container runtime for `make up`/`make down` (defaults to `docker` if unset). The `AWS_*` vars point the provider at Floci rather than real AWS -- Floci doesn't validate credentials, but the AWS provider still requires them to be set. `TF_WORKSPACE` selects the active Terraform workspace, per "Switching workspaces" above.
