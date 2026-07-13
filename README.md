#  ShopFast E-Commerce Platform - DevOps Project

A complete cloud-native microservices e-commerce platform deployed on **Amazon EKS** using **Terraform**, **Docker**, **Kubernetes**, **GitHub Actions**, **Ansible**, and **Prometheus/Grafana Monitoring**.

---

#  Project Overview

This project demonstrates the implementation of a production-style DevOps workflow:

* Infrastructure as Code (Terraform)
* Containerization (Docker)
* Kubernetes Orchestration (Amazon EKS)
* CI/CD Pipeline (GitHub Actions)
* Configuration Management (Ansible)
* Monitoring & Observability (Prometheus & Grafana)
* AWS Cloud Services Integration

---

#  Architecture

```text
Developer
    │
    ▼
GitHub Repository
    │
    ├── CI Pipeline
    │      ├── Build Docker Images
    │      └── Push Images to Amazon ECR
    │
    └── CD Pipeline
           └── Deploy to Amazon EKS
                      │
                      ▼
            Kubernetes Cluster
            ├── API Service
            ├── Payment Service
            ├── Search Service
            ├── Web Service
            └── PostgreSQL

Monitoring Stack
├── Prometheus
└── Grafana
```

---

# Technologies Used

## Cloud

* AWS VPC
* Amazon EKS
* Amazon ECR
* EC2 Bastion Host
* Elastic Load Balancer (ALB)

## Infrastructure as Code

* Terraform

## Containers

* Docker
* Docker Compose

## Orchestration

* Kubernetes

## CI/CD

* GitHub Actions

## Configuration Management

* Ansible

## Monitoring

* Prometheus
* Grafana

## Programming

* Node.js Microservices

---

#  Project Structure

```text
shopfast-ecommerce-platform/
│
├── services/
│   ├── api/
│   ├── payment/
│   ├── search/
│   └── web/
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── ecr/
│   │   └── ec2/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── k8s/
│   ├── 00-namespace.yaml
│   ├── 01-secrets-config.yaml
│   ├── 02-postgres.yaml
│   ├── 03-api.yaml
│   ├── 04-payment.yaml
│   ├── 05-search.yaml
│   ├── 06-web.yaml
│   └── 07-ingress.yaml
│
├── ansible/
│   ├── inventory.ini
│   ├── ansible.cfg
│   ├── playbooks/
│   └── roles/
│
├── monitoring/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cd.yml
│
└── README.md
```

---

#  Infrastructure Components

## VPC

* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

## Amazon EKS

* Managed Kubernetes Cluster
* 2 Worker Nodes
* Private Networking

## Amazon ECR

Repositories:

* ecommerce-devops-api
* ecommerce-devops-payment
* ecommerce-devops-search
* ecommerce-devops-web

## Bastion Host

* Amazon Linux 2023
* Docker
* kubectl
* eksctl
* Helm
* Ansible

---

#  Docker

Each microservice has its own Docker image.

Example:

```bash
docker build -t ecommerce-devops-api .
```

---

#  Kubernetes Deployment

Deployments:

* PostgreSQL
* API
* Payment
* Search
* Web

Services:

* ClusterIP Services
* LoadBalancer / Ingress

Deployment:

```bash
kubectl apply -f k8s/
```

---

#  CI/CD Pipeline

## Continuous Integration

Triggered on:

```text
Push to main branch
```

Pipeline:

1. Checkout repository
2. Configure AWS credentials
3. Login to Amazon ECR
4. Build Docker Images
5. Push Images to ECR

---

## Continuous Deployment

Triggered after successful CI.

Pipeline:

1. Configure kubeconfig
2. Replace image placeholders
3. Deploy manifests to EKS
4. Verify deployments
5. Display cluster resources

---

#  Monitoring

Monitoring stack:

* Prometheus
* Grafana
* Node Exporter
* kube-state-metrics

Metrics:

* CPU Usage
* Memory Usage
* Pod Information
* Cluster Health

---

#  GitHub Secrets

Required secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_ACCOUNT_ID
EKS_CLUSTER_NAME
ECR_REGISTRY
```

---

#  Deployment Steps

## 1. Provision Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

---

## 2. Configure Kubernetes

```bash
aws eks update-kubeconfig \
--region us-east-1 \
--name ecommerce-devops-cluster
```

---

## 3. Verify Cluster

```bash
kubectl get nodes
```

---

## 4. Deploy Application

```bash
kubectl apply -f k8s/
```

---

## 5. Check Resources

```bash
kubectl get pods -n ecommerce
kubectl get svc -n ecommerce
kubectl get ingress -n ecommerce
```

---

#  Accessing Grafana

```bash
kubectl port-forward svc/monitoring-grafana \
-n monitoring 3000:80
```

Open:

```text
http://localhost:3000
```

---

#  Project Features

- Infrastructure as Code

- Kubernetes Orchestration

- CI/CD Automation

- Dockerized Microservices

- Monitoring & Observability

- Automated Deployments

- AWS Cloud Native Architecture

---

#  Author

**Ali Ahmed**

DevOps Engineer 

* GitHub: https://github.com/Ali-Hafour
* LinkedIn: https://www.linkedin.com/

