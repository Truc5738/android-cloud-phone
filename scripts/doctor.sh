#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."

echo "== Android Cloud Phone preflight =="
command -v docker >/dev/null 2>&1 || { echo "FAIL: Docker is not installed."; exit 1; }
docker info >/dev/null 2>&1 || { echo "FAIL: Docker daemon is not running or this user lacks permission."; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "FAIL: Docker Compose plugin is missing."; exit 1; }

if [[ -e /dev/kvm ]]; then
  echo "OK: /dev/kvm exists"
  if [[ -r /dev/kvm && -w /dev/kvm ]]; then
    echo "OK: current user can access /dev/kvm"
  else
    echo "WARN: current user may not have permission to use /dev/kvm"
  fi
else
  echo "FAIL: /dev/kvm is missing. This host likely cannot run the emulator with hardware acceleration."
  exit 2
fi

if command -v free >/dev/null 2>&1; then
  free -h
else
  echo "WARN: 'free' command unavailable; check host RAM manually (2 GB shared memory is configured)."
fi

docker compose config -q || { echo "FAIL: docker-compose.yml is invalid."; exit 1; }
echo "OK: Compose configuration parses."
echo "NOTE: This check does not start Android or prove that the host has enough CPU/RAM."
