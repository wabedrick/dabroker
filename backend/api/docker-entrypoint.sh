#!/bin/sh
set -e

echo "Creating storage symlink..."
php artisan storage:link --force

echo "Running migrations..."
php artisan migrate --force

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Starting server..."
exec /start.sh
