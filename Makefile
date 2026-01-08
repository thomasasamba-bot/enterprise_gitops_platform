
# Enterprise GitOps Platform Makefile

# Variables
APPS_DIR := services
INFRA_DIR := infrastructure/terraform

.PHONY: all build-frontend build-auth build-payment build-order build-product terraform-validate clean

all: build-frontend build-auth build-payment build-order build-product terraform-validate

# Frontend (Next.js)
build-frontend:
	@echo "Building Frontend..."
	cd $(APPS_DIR)/frontend && npm install && npm run build
	cd $(APPS_DIR)/frontend && docker build -t frontend:latest .

# Auth Service (Node.js)
build-auth:
	@echo "Building Auth Service..."
	cd $(APPS_DIR)/auth-service && npm install
	cd $(APPS_DIR)/auth-service && docker build -t auth-service:latest .

# Payment Service (Go)
build-payment:
	@echo "Building Payment Service..."
	cd $(APPS_DIR)/payment-service && go build -o bin/payment-service main.go
	cd $(APPS_DIR)/payment-service && docker build -t payment-service:latest .

# Order Service (Python)
build-order:
	@echo "Building Order Service..."
	cd $(APPS_DIR)/order-service && docker build -t order-service:latest .

# Product Service (Java)
# Note: Local compilation skipped as Java might not be present. Using Docker for build.
build-product:
	@echo "Building Product Service..."
	cd $(APPS_DIR)/product-service && docker build -t product-service:latest .

# Infrastructure
terraform-validate:
	@echo "Validating Terraform Configuration..."
	cd $(INFRA_DIR) && terraform init -backend=false && terraform validate

clean:
	@echo "Cleaning up..."
	rm -rf $(APPS_DIR)/frontend/.next
	rm -rf $(APPS_DIR)/payment-service/bin
	rm -rf $(APPS_DIR)/auth-service/node_modules
