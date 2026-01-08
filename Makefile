
# Enterprise GitOps Platform Makefile

# Variables
APPS_DIR := services
INFRA_DIR := infrastructure/terraform
AWS_REGION := us-east-1
CLUSTER_NAME := enterprise-gitops-cluster

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

# ============================================
# ArgoCD Management Commands
# ============================================

.PHONY: eks-config argocd-install argocd-login argocd-deploy-root argocd-status argocd-sync-all argocd-uninstall

# Configure kubectl for EKS cluster
eks-config:
	@echo "Configuring kubectl for EKS cluster..."
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(CLUSTER_NAME)
	@echo "Testing connection..."
	kubectl cluster-info

# Install ArgoCD on EKS
argocd-install:
	@echo "Installing ArgoCD..."
	kubectl create namespace argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@echo "Waiting for ArgoCD to be ready (this may take a few minutes)..."
	kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
	@echo "\n✅ ArgoCD installed successfully!"
	@echo "\nTo access ArgoCD UI, run: make argocd-login"

# Get ArgoCD admin password and port-forward
argocd-login:
	@echo "========================================="
	@echo "ArgoCD Admin Credentials"
	@echo "========================================="
	@echo "Username: admin"
	@echo -n "Password: "
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d || echo "Secret not found - ArgoCD may not be installed"
	@echo "\n========================================="
	@echo "\nStarting port-forward to localhost:8080..."
	@echo "Access ArgoCD UI at: https://localhost:8080"
	@echo "Press Ctrl+C to stop port-forwarding"
	@echo "========================================="
	kubectl port-forward svc/argocd-server -n argocd 8080:443

# Deploy root application (App-of-Apps pattern)
argocd-deploy-root:
	@echo "Deploying root application..."
	kubectl apply -f gitops/root-app.yaml
	@echo "\n✅ Root application deployed!"
	@echo "Run 'make argocd-status' to check application status"

# Check ArgoCD application status
argocd-status:
	@echo "========================================="
	@echo "ArgoCD Applications Status"
	@echo "========================================="
	kubectl get applications -n argocd
	@echo "\n========================================="
	@echo "Kubernetes Deployments"
	@echo "========================================="
	kubectl get deployments -n default
	@echo "\n========================================="
	@echo "Kubernetes Pods"
	@echo "========================================="
	kubectl get pods -n default

# Sync all applications
argocd-sync-all:
	@echo "Syncing all applications..."
	@echo "Note: This requires argocd CLI to be installed"
	@command -v argocd >/dev/null 2>&1 || { echo "argocd CLI not found. Install from: https://argo-cd.readthedocs.io/en/stable/cli_installation/"; exit 1; }
	argocd app sync -l app.kubernetes.io/instance=root-app

# Uninstall ArgoCD (use with caution)
argocd-uninstall:
	@echo "⚠️  WARNING: This will uninstall ArgoCD and all applications!"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read confirm
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl delete namespace argocd

# Create ECR image pull secret
ecr-secret:
	@echo "Creating ECR image pull secret..."
	@ECR_REGISTRY=$$(cd $(INFRA_DIR) && terraform output -raw ecr_registry 2>/dev/null) && \
	aws ecr get-login-password --region $(AWS_REGION) | \
	kubectl create secret docker-registry ecr-registry-secret \
		--docker-server=$$ECR_REGISTRY \
		--docker-username=AWS \
		--docker-password=$$(cat -) \
		--namespace=default \
		--dry-run=client -o yaml | kubectl apply -f -
	@echo "✅ ECR secret created/updated in default namespace"

# Full ArgoCD setup (run this after terraform apply)
argocd-setup: eks-config argocd-install ecr-secret argocd-deploy-root
	@echo "\n========================================="
	@echo "✅ ArgoCD Setup Complete!"
	@echo "========================================="
	@echo "Next steps:"
	@echo "1. Run 'make argocd-login' to access the UI"
	@echo "2. Run 'make argocd-status' to check application status"
	@echo "3. Configure repository credentials if using private repo"
	@echo "========================================="
