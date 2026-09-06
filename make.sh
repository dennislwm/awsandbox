function check_terraform {
  command -v terraform > /dev/null 2>&1 || { echo "[ERROR][$FUNCNAME]: terraform not installed."; return 1; }
  echo "[OK]   terraform found ($(terraform version | head -1 | sed 's/^Terraform v//'))"
}

function check_docker {
  command -v docker > /dev/null 2>&1 || { echo "[ERROR][$FUNCNAME]: docker not installed -- required to run Floci."; return 1; }
  echo "[OK]   docker found ($(docker --version 2>&1))"
  if curl -sf http://localhost:4566/_localstack/health > /dev/null 2>&1; then
    echo "[OK]   floci reachable at localhost:4566"
  else
    echo "[WARN][$FUNCNAME]: floci not reachable at localhost:4566 -- run 'make up' to start it."
  fi
}

function setup_terraform {
  terraform init
}

function setup_docker {
  echo "[INFO] Floci is not installed as a binary -- it runs as a Docker image."
  echo "[INFO] Start it with: make up"
  echo "[INFO] Then point Terraform/AWS SDK at it with AWS_ENDPOINT_URL=http://localhost:4566"
}

function show_status {
  echo ""
  echo "=== Status ==="
  check_terraform || true
  check_docker || true
  echo "=============="
  echo ""
}

function setup_commands {
  echo "=== awsandbox Setup ==="
  check_terraform
  setup_terraform
  check_docker
  setup_docker
  echo "========================"
}
