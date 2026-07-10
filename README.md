# ShopFast — Automated E-Commerce Deployment Platform

منصة تجارة إلكترونية Microservices كاملة (Web / API / Payment / Search / Postgres)
مع CI/CD, Docker, Kubernetes auto-scaling, Ansible, Terraform (AWS), Prometheus/Grafana, Nginx, وrollback تلقائي.

راجع الشرح التفصيلي في الرسالة المرفقة بالعربي لكل خطوة وليه اتعملت كده.

## تشغيل سريع محلي
```bash
docker compose up --build
# افتح http://localhost
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3001 (admin/admin)
```

## هيكل المشروع
```
services/       -> web, api, payment, search (Node.js + Express, كل واحدة معاها Dockerfile)
nginx/          -> reverse proxy config
k8s/            -> Kubernetes manifests (namespace, postgres, deployments, HPA, ingress)
ansible/        -> playbook لتجهيز السيرفرات (Docker + K8s prerequisites + Jenkins)
terraform/      -> بنية AWS (VPC, EC2, RDS, S3, ALB)
jenkins/        -> Jenkinsfile لل CI/CD pipeline
monitoring/     -> Prometheus config + ملاحظات Grafana dashboards
scripts/        -> rollback.sh للـ rollback اليدوي السريع
```
