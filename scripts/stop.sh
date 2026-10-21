#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
docker compose stop android
echo "Android container stopped. The ./data directory was not deleted."
