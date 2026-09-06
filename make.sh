CONTAINER_CMD="${CONTAINER_CMD:-docker}"

function check_terraform {
  command -v terraform > /dev/null 2>&1 || { echo "[ERROR][$FUNCNAME]: terraform not installed."; return 1; }
  echo "[OK]   terraform found ($(terraform version | head -1 | sed 's/^Terraform v//'))"
}

function check_docker {
  command -v "${CONTAINER_CMD}" > /dev/null 2>&1 || { echo "[ERROR][$FUNCNAME]: ${CONTAINER_CMD} not installed -- required to run Floci."; return 1; }
  echo "[OK]   ${CONTAINER_CMD} found ($(${CONTAINER_CMD} --version 2>&1))"
  if curl -sf http://localhost:4566/_localstack/health > /dev/null 2>&1; then
    echo "[OK]   floci reachable at localhost:4566"
  else
    echo "[WARN][$FUNCNAME]: floci not reachable at localhost:4566 -- run 'make up' to start it."
  fi
}

function floci_up {
  if ${CONTAINER_CMD} ps --filter name=floci --filter status=running --quiet | grep -q .; then
    echo "[SKIP] floci already running"
  else
    ${CONTAINER_CMD} run -d --rm -p 4566:4566 -v floci-data:/var/lib/floci --name floci floci/floci:2.0.1
  fi
}

function floci_down {
  ${CONTAINER_CMD} stop floci
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
