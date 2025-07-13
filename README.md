# DevOps Project

## Stack
- AWS EKS (via Terraform)
- AWS S3 (Terraform state)
- Docker & ECR
- GitHub Actions
- Node.js Web App


## Infrastructure Provisioning

```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

### Includes:

- VPC
- EKS Cluster
- Node Group
- S3 Backend
- Hello-world Application

### Hello World App
Located in /webapp, with a /healthz endpoint returning 200 OK.

### Docker
docker build -t <image> .
docker push <image>

## CI/CD Pipeline

### Trigger: push to main.

### Steps:

- Builds Docker image
- Pushes to ECR
- Applies K8s manifests
- Waits for LoadBalancer
- Health-checks /healthz

## Manual Verification

```
kubectl get svc webapp-service
curl http://<external-LB>/healthz
```

- Should return 200 OK.
