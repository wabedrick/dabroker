# Environment Configuration Reference

Use this guide to populate `.env` files (local, staging, production) securely. Never commit real secrets.

## Core Application
| Key | Description | Example |
|-----|-------------|---------|
| `APP_NAME` | Display name for logs/mail | `Broker Backend`
| `APP_ENV` | `local`, `staging`, `production` | `production`
| `APP_DEBUG` | Disable in prod | `false`
| `APP_URL` | Base API URL | `https://api.broker.com`
| `FRONTEND_URL` | Flutter deep-link origin / admin SPA | `https://app.broker.com`
| `APP_FORCE_HTTPS` | Force HTTPS redirects when behind load balancer | `true`
| `ASSET_URL` | CDN for media | `https://cdn.broker.com`

## Database & Cache
| Key | Description |
|-----|-------------|
| `DB_CONNECTION` (`mysql`/`pgsql`) with `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` |
| `READ_DATABASE_HOST` | Optional replica for read-heavy queries |
| `CACHE_STORE` | `redis` preferred |
| `QUEUE_CONNECTION` | `redis` or `database` |
| `REDIS_HOST`, `REDIS_PASSWORD`, `REDIS_CACHE_DB`, `REDIS_QUEUE_DB` |

## Authentication & Sessions
| Key | Description |
|-----|-------------|
| `SANCTUM_STATEFUL_DOMAINS` | Allowed first-party domains for SPA/mobile auth |
| `SANCTUM_EXPIRATION` | Token TTL in minutes (set to `null` for non-expiring) |
| `SESSION_DRIVER` (`database`), `SESSION_DOMAIN`, `SESSION_LIFETIME` |
| `APP_KEY` | Generated via `php artisan key:generate` |

## Media & Storage
| Key | Description |
|-----|-------------|
| `FILESYSTEM_DISK` | Default disk (`private`, `s3`, etc.) |
| `MEDIA_DISK` | Disk used by MediaLibrary |
| `MEDIA_LIBRARY_MAX_FILE_SIZE`, `MEDIA_LIBRARY_ALLOWED_MIME` | Upload enforcement |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_BUCKET`, `AWS_DEFAULT_REGION`, `AWS_URL`, `AWS_USE_PATH_STYLE_ENDPOINT` |

## Search & Maps
| Key | Description |
|-----|-------------|
| `SCOUT_DRIVER` (`meilisearch`, `typesense`, `database`) |
| `SCOUT_QUEUE` | `true` to sync via queues |
| `MEILISEARCH_HOST`, `MEILISEARCH_KEY` or Typesense equivalents |
| `MAP_PROVIDER` (`google`, `mapbox`) |
| `MAPS_API_KEY` | Server-side geocoding + map tiles |

## Messaging & Notifications
| Key | Description |
|-----|-------------|
| `OTP_PROVIDER` (`twilio`, `sns`, etc.)
| `OTP_PROVIDER_KEY` / `OTP_PROVIDER_SECRET` / `OTP_SENDER_ID`
| `OTP_TTL`, `OTP_MAX_ATTEMPTS` | OTP expiry (seconds) and retry ceilings |
| `OTP_TWILIO_ACCOUNT_SID`, `OTP_TWILIO_AUTH_TOKEN`, `OTP_TWILIO_FROM` or `OTP_TWILIO_MESSAGING_SERVICE_SID` | Required when `OTP_PROVIDER=twilio` |
| `FCM_SERVER_KEY`, `FCM_SENDER_ID` |
| `MAIL_MAILER`, `MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_FROM_ADDRESS`, `MAIL_FROM_NAME` |

## Observability & Security
| Key | Description |
|-----|-------------|
| `SENTRY_LARAVEL_DSN` | Error tracking |
| `LOG_SLACK_WEBHOOK_URL` | Critical alert channel |
| `APP_LOG_LEVEL` | Raise to `warning`/`error` in prod |

## Feature Flags
- Use `config('features.*')` (to be added) mapped to env keys like `FEATURE_BOOKING_REVIEWS=true` for safe rollouts.

## Secrets Handling
- Store values in Azure Key Vault / AWS Secrets Manager.
- Load into runtime via CI/CD or parameter store; never hardcode.
- Rotate OTP/map/storage keys on a schedule and update envs.

Populate `.env`, run `php artisan config:clear && php artisan config:cache`, and verify `php artisan about` to ensure variables surfaced correctly.
