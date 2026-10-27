#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if docker compose version >/dev/null 2>&1; then
  compose=(docker compose)
  compose_supports_wait=true
elif command -v docker-compose >/dev/null 2>&1; then
  compose=(docker-compose)
  compose_supports_wait=false
else
  echo "Docker Compose v2 or docker-compose is required." >&2
  exit 1
fi

service="${1:-all}"
source_dir="${2:-}"
case "$service" in
  all|frontend|backend) ;;
  *) echo "Usage: bash scripts/deploy.sh [all|frontend|backend] [source-directory]" >&2; exit 2 ;;
esac
if [[ "$service" == all && -n "$source_dir" ]]; then
  echo "Build each application independently before deploying all services." >&2
  exit 2
fi

# All repositories on this VM share one deployment lock.
exec 9>.deploy.lock
flock -w 1800 9
"${compose[@]}" config --quiet

if [[ -n "$source_dir" ]]; then
  # The image name comes from infra, including any .env override.
  if [[ "$compose_supports_wait" != true ]]; then
    echo "Building from a source directory requires Docker Compose v2." >&2
    exit 1
  fi
  image="$("${compose[@]}" config --format json | jq -er --arg service "$service" '.services[$service].image')"
  docker build -t "$image" "$source_dir"
fi

if [[ "$service" == all ]]; then
  if [[ "$compose_supports_wait" == true ]]; then
    "${compose[@]}" up -d --wait --wait-timeout 180
  else
    "${compose[@]}" up -d
  fi
else
  if [[ "$service" == backend ]]; then
    if [[ "$compose_supports_wait" == true ]]; then
      "${compose[@]}" up -d --wait --wait-timeout 90 mongo
    else
      "${compose[@]}" up -d mongo
    fi
  fi
  # Independent updates must not recreate the other application.
  if [[ "$compose_supports_wait" == true ]]; then
    "${compose[@]}" up -d --no-deps --wait --wait-timeout 180 "$service"
  else
    "${compose[@]}" up -d --no-deps "$service"
  fi
fi

if [[ "$service" == frontend || "$service" == all ]]; then
  # Check the API through Nginx, not just the static HTML.
  for attempt in $(seq 1 15); do
    if "${compose[@]}" exec -T frontend wget -q -O /dev/null http://127.0.0.1/api/state; then
      exit 0
    fi
    sleep 2
  done
  echo "Frontend is running but the API is unreachable through Nginx." >&2
  exit 1
fi
