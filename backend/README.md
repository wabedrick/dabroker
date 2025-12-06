# Broker Laravel Backend

API layer, admin panel, messaging, and background services powering the Broker platform.

## Requirements
- PHP 8.3+
- Composer 2.x
- MySQL 8 or PostgreSQL 15
- Redis 7
- Node.js 20 LTS (for Vite build of admin UI)

## Initial Setup
```bash
composer create-project laravel/laravel api
cd api
cp .env.example .env  # or use per-environment secret manager templates
php artisan key:generate
php artisan migrate
php artisan serve
```

After cloning an existing repo, run `composer install`, `php artisan migrate`, and seed baseline data (`php artisan db:seed --class=BasePermissionsSeeder`).

## Core Packages
- `laravel/sanctum` – token auth for Flutter client + admin panel (installed)
- `spatie/laravel-permission` – fine-grained RBAC across buyer/seller/host/pro roles (installed)
- `spatie/laravel-activitylog` – immutable audit trail for admin actions and bookings (installed)
- `laravel/scout` – search abstraction (configure driver: Meilisearch/Elastic/OpenSearch) (installed)
- `spatie/laravel-medialibrary` – secure media handling with transformations (installed)
- `laravel/horizon` – queue dashboard (requires pcntl/posix extensions; install once backend runs on Linux/WSL)
- `maatwebsite/excel` – exporting reports (planned)
- `laravel/telescope` – observability (planned)

### Post-Install Publishing
Run the following after `composer install` to publish configs/migrations:
```bash
php artisan vendor:publish --provider="Laravel\\Sanctum\\SanctumServiceProvider"
php artisan vendor:publish --provider="Spatie\\Permission\\PermissionServiceProvider"
php artisan vendor:publish --provider="Spatie\\Activitylog\\ActivitylogServiceProvider"
php artisan vendor:publish --provider="Spatie\\MediaLibrary\\MediaLibraryServiceProvider"
php artisan vendor:publish --provider="Laravel\\Scout\\ScoutServiceProvider"
php artisan migrate
```

> **Note**: Horizon is deferred until we run PHP with `ext-pcntl`/`ext-posix` (Linux container or WSL). Queue workers can still run via `php artisan queue:work` locally.

## Environment Configuration
- Duplicate `.env.example` per environment (`.env.development`, `.env.staging`, etc.) and load via `php artisan config:cache`.
- Required secrets: DB credentials, `SCOUT_DRIVER`, `SCOUT_QUEUE`, `SANCTUM_STATEFUL_DOMAINS`, `MEDIA_DISK`, OTP provider keys, map provider keys, mail credentials.
- Enforce HTTPS locally via `APP_URL=https://...` with Valet/Ngrok for callback testing.
- Use `config/permission.php`, `config/activitylog.php`, and `config/media-library.php` to align with security policies (e.g., `media-library` private disk default).
- Full variable reference: see `docs/env_reference.md`.
- OTP provider: default is `log`. To enable Twilio SMS, set `OTP_PROVIDER=twilio` and populate `OTP_TWILIO_ACCOUNT_SID`, `OTP_TWILIO_AUTH_TOKEN`, plus either `OTP_TWILIO_FROM` or `OTP_TWILIO_MESSAGING_SERVICE_SID`.

## Security & Performance Checklist
- Enforce HTTPS via load balancer + `AppServiceProvider` force scheme.
- Configure rate limiting per route group (auth, listings, messaging) using `RateLimiter` facade.
- Sanitize inputs through Form Requests, cast attributes, and use validation rules for file uploads (size/type).
- Use caching (Redis) for catalogs, map clusters, and configuration.
- Cover APIs with PHPUnit feature tests + Pest; include performance smoke tests via Artillery/K6.

## Local Tooling
- `sail` or `laravel-herd` for simplified containers.
- `phpstan`/`larastan` level 8, `pint` for formatting.
- Pre-commit hooks running Pint, PHPStan, PHPUnit subset, secret scan.

Refer to `docs/architecture_overview.md` and `docs/quality_principles.md` for deeper expectations.
