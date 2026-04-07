
# EKS Microservices Demo

A production-grade microservices application deployed on AWS EKS using Terraform, Kubernetes, and Helm.

## Architecture

- **Cloud Provider**: AWS
- **Container Orchestration**: Amazon EKS (Kubernetes 1.32)
- **Infrastructure as Code**: Terraform (modular structure)
- **Container Registry**: Amazon ECR
- **Observability**: Prometheus + Grafana
- **Autoscaling**: Horizontal Pod Autoscaler (HPA)

## Project Structure

```
.
├── terraform-eks/
│   ├── bootstrap/          # S3 bucket and DynamoDB for Terraform state
│   ├── live/
│   │   └── Dev/            # Dev environment entry point
│   └── modules/
│       ├── network/        # VPC, subnets, IGW, NAT gateway
│       ├── security/       # Security groups
│       ├── IAM/            # EKS cluster and node IAM roles
│       ├── eks/            # EKS cluster and node group
│       └── ecr/            # ECR repositories
└── k8s/
    ├── frontend.yaml
    ├── cartservice.yaml
    ├── checkoutservice.yaml
    ├── currencyservice.yaml
    ├── emailservice.yaml
    ├── paymentservice.yaml
    ├── productcatalogservice.yaml
    ├── recommendationservice.yaml
    ├── shippingservice.yaml
    ├── adservice.yaml
    ├── loadgenerator.yaml
    └── hpa/
        └── hpa.yaml
```

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- kubectl
- Helm v3+
- Docker

## Infrastructure Setup

### 1. Bootstrap (Remote State)

```bash
cd terraform-eks/bootstrap
terraform init
terraform apply
```

### 2. Deploy Infrastructure

```bash
cd terraform-eks/live/Dev
terraform init
terraform apply
```

This creates:
- VPC with public and private subnets across 2 AZs
- NAT Gateway for private subnet internet access
- EKS cluster with managed node group
- ECR repository for container images
- IAM roles for cluster and nodes
- Security groups

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --name online-boutique-dev --region us-east-2 --profile terraform
```

## Application Deployment

### Build and Push Images to ECR

```bash
cd microservices-demo

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-2.amazonaws.com

for service in adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice; do
  docker build -t <account-id>.dkr.ecr.us-east-2.amazonaws.com/my-eks-app:$service-v1 ./src/$service
  docker push <account-id>.dkr.ecr.us-east-2.amazonaws.com/my-eks-app:$service-v1
done
```

### Deploy to Kubernetes

```bash
kubectl apply -f k8s/
```

### Deploy HPA

```bash
kubectl apply -f k8s/hpa/
```

## Observability

### Install Prometheus + Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

### Access Grafana

```bash
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
```

Open `http://localhost:3000` — username: `admin`

Get password:
```bash
kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode
```

## Autoscaling

HPA is configured for the frontend service:
- Min replicas: 3
- Max replicas: 10
- Scale up when CPU > 70%

```bash
kubectl get hpa
```

## Teardown

```bash
cd terraform-eks/live/Dev
terraform destroy
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| frontend | 8080 | Web UI |
| cartservice | 7070 | Shopping cart |
| checkoutservice | 5050 | Order checkout |
| currencyservice | 7000 | Currency conversion |
| emailservice | 8080 | Email notifications |
| paymentservice | 50051 | Payment processing |
| productcatalogservice | 3550 | Product catalog |
| recommendationservice | 8080 | Product recommendations |
| shippingservice | 50051 | Shipping quotes |
| adservice | 9555 | Advertisements |
=======
# Eks-online-boutique
Production-grade deployment of a microservices Online Boutique on AWS EKS. Built with OpenTofu for Infrastructure as Code (Terraform compatible), leveraging Helm for orchestration and IRSA for secure identity management. Showcases scalable, cloud-native architecture and automated environment provisioning.

