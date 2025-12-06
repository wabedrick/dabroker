# Broker Platform

Unified real estate and lodging marketplace built with a Flutter mobile client and Laravel backend. This repository hosts documentation, mobile source, backend source, and operational assets.

## Repository Layout
- `docs/` – architecture, roadmap, quality, and UI design references.
- `mobile_app/` – Flutter application source (to be initialized with `flutter create`).
- `backend/` – Laravel API + admin panel (to be initialized with `laravel new`).

## Development Principles
- **Security First**: OWASP-aligned coding, zero-trust APIs, encrypted data paths, secret rotation.
- **Performance Obsessed**: sub-100ms interactions on device, API p95 < 3s, load/regression tests per sprint.
- **Responsive & Accessible UI**: design tokens, adaptive layouts, WCAG AA compliance, offline resilience.
- **Operational Excellence**: CI/CD gating on tests/lints/security scans, automated backups, observability dashboards.

## Getting Started
1. **Flutter Setup**
   - Install Flutter 3.24+, enable iOS/Android toolchains.
   - From `mobile_app/`, run `flutter create --platforms=android,ios broker_app` (or use existing template when added).
   - Configure Firebase project for push notifications and analytics (per `docs/architecture_overview.md`).

2. **Laravel Setup**
   - Install PHP 8.3+, Composer, Node.js LTS.
   - From `backend/`, run `laravel new api && cd api` or clone the prepared skeleton when available.
   - Configure `.env` with DB, Redis, mail, storage, and external API credentials. Reference `docs/quality_principles.md` for security requirements.

3. **CI/CD & Tooling**
   - Configure GitHub Actions workflows for both apps (unit/widget tests, Pint/ESLint, PHPUnit, Dusk, SAST tools).
   - Add dependency scanners (Dependabot, Composer Audit, Flutter pub outdated) and performance budgets.

## Next Actions
- Initialize Flutter and Laravel projects following Sprint 0 plan in `docs/implementation_roadmap.md`.
- Implement design token pipeline and the `broker_design_system` package per `docs/ui_design_system.md`.
- Stand up security/performance testing harnesses to continually enforce the documented quality bar.
