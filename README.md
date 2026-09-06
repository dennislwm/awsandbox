# 19awsandbox

Terraform project for AWS infrastructure, validated against Floci (a local AWS emulator) before applying to real AWS.

Requires: [Terraform >= 1.9.2](https://developer.hashicorp.com/terraform/install)

## Workflow

1. `make setup` -- initializes Terraform and checks for Docker (required to run [Floci](https://floci.io), a local AWS emulator).
2. `make up` -- starts Floci in Docker (`make down` stops it).
3. `make test` -- runs `terraform test` before touching any real infrastructure.
4. `make validate` -- checks Terraform config syntax.
5. `make plan` / `make apply` -- provisions against whatever `AWS_ENDPOINT_URL`/provider config is currently active (Floci locally, real AWS once verified). Against Floci, the AWS provider still requires credential env vars to be *set* (Floci doesn't validate them):

   ```
   export AWS_ENDPOINT_URL=http://localhost:4566
   export AWS_ACCESS_KEY_ID=test
   export AWS_SECRET_ACCESS_KEY=test
   make plan
   ```
