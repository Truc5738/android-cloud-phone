#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
mkdir -p data
if [ ! -e /dev/kvm ]; then
  echo "ERROR: /dev/kvm is missing. This host likely cannot run hardware-accelerated Android Emulator."
  echo "GitHub Actions and Vercel are not persistent Android hosts."
  exit 1
fi
docker compose up -d
echo "Container requested. Check startup with: docker compose logs -f android"
echo "Web UI is bound to localhost:6080; use an SSH tunnel/VPN for remote access."
