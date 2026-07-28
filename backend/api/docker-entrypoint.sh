#!/bin/sh
set -e

echo "=== Starting dabroker-backend-api ==="

# Storage symlink — use || true so a pre-existing link doesn't abort boot
echo "[1/4] Creating storage symlink..."
php artisan storage:link --force || echo "WARNING: storage:link failed (non-fatal)"

# Migrations — this MUST succeed; if the DB is unreachable the container
# should crash so DigitalOcean knows to keep rolling back
echo "[2/4] Running migrations..."
php artisan migrate --force

# Config & route cache — if these fail (e.g. bad env var reference) we
# skip them so the app still boots in an uncached state rather than dying
echo "[3/4] Caching config..."
php artisan config:cache || echo "WARNING: config:cache failed, running without cache"

echo "[4/4] Caching routes..."
php artisan route:cache || echo "WARNING: route:cache failed, running without cache"

echo "=== Handing off to web server ==="
exec /start.sh
