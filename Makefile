.PHONY: help setup status test validate plan apply up down
SHELL := /bin/bash

help:
	@echo ""
	@echo "Workflow: setup -> up (start Floci) -> test (terraform test) -> plan/apply (manual, against whatever AWS_ENDPOINT_URL/provider config is in effect -- Floci or real AWS) -> down (stop Floci)"
	@echo ""
	@echo "=== Targets ==="
	@echo "  help     Show this help"
	@echo "  setup    terraform init"
	@echo "  status   Check system dependencies (terraform, container runtime -- CONTAINER_CMD, default docker)"
	@echo "  up       Start Floci (local AWS emulator) in Docker"
	@echo "  down     Stop Floci"
	@echo "  test     terraform test"
	@echo "  validate terraform validate"
	@echo "  plan     terraform plan"
	@echo "  apply    terraform apply"
	@echo ""

up:
	@source ./make.sh && floci_up

down:
	@source ./make.sh && floci_down

setup:
	@source ./make.sh && setup_commands

status:
	@source ./make.sh && show_status

test:
	@source ./make.sh && check_terraform
	terraform test

validate:
	@source ./make.sh && check_terraform
	terraform validate

plan:
	@source ./make.sh && check_terraform
	terraform plan

apply:
	@source ./make.sh && check_terraform
	terraform apply
