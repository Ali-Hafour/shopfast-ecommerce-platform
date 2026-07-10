# Grafana Dashboards

Import these dashboard IDs from grafana.com after connecting Prometheus as a data source:
- Node Exporter Full: 1860
- Kubernetes Cluster Monitoring: 315
- NGINX Ingress Controller: 9614

Or build a custom dashboard querying:
- `rate(http_request_duration_seconds_count[5m])` — requests/sec per service
- `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))` — p95 latency
- `up{job="api"}` — service availability
