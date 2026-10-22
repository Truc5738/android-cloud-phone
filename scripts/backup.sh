#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."

if docker container inspect android-cloud-phone >/dev/null 2>&1; then
  echo "Stopping the container briefly for a consistent backup..."
  docker compose stop android
  restart_after=1
else
  restart_after=0
fi

cleanup() {
  if [[ "$restart_after" == "1" ]]; then
    docker compose start android >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

if [[ ! -d data ]]; then
  echo "No ./data directory exists yet; there may be no emulator data to back up."
  exit 1
fi

stamp="$(date -u +%Y%m%dT%H%M%SZ)"
out="${1:-android-cloud-phone-backup-${stamp}.tar.gz}"
case "$out" in
  /*) ;;
  *) out="../$out" ;;
esac

tar -czf "$out" data
echo "Backup created: $out"
echo "Store this archive somewhere private. It may contain app data and session credentials."
