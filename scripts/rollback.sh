#!/usr/bin/env bash
# Manual emergency rollback — usage: ./rollback.sh <service-name>
# Rolls a single deployment back to the previous ReplicaSet revision.
set -euo pipefail
SVC="${1:?Usage: rollback.sh <service>}"
NS="ecommerce"

echo "Rolling back deployment/${SVC} in namespace ${NS}..."
kubectl rollout undo deployment/"${SVC}" -n "${NS}"
kubectl rollout status deployment/"${SVC}" -n "${NS}" --timeout=90s
echo "Rollback complete. Current revision:"
kubectl rollout history deployment/"${SVC}" -n "${NS}" | tail -n 3
