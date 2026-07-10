# Kubernetes Manifests — apply order

1. `kubectl apply -f 00-namespace.yaml`
2. `kubectl apply -f 01-secrets-config.yaml`
3. `kubectl apply -f 02-postgres.yaml`
4. `kubectl apply -f 03-api.yaml -f 04-payment.yaml -f 05-search.yaml -f 06-web.yaml`
5. `kubectl apply -f 07-ingress.yaml`

Or simply: `kubectl apply -f .` (namespace/secret are safe to re-apply first).

Replace `<REGISTRY>` in 03/04/05/06 with your image registry (Docker Hub user, or AWS ECR URI) —
this gets substituted automatically by the Jenkins pipeline using `sed`.

For monitoring, install kube-prometheus-stack via Helm instead of hand-rolled manifests:
`helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace`
