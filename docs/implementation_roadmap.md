# Implementation Roadmap

The roadmap is organized into milestone waves spanning ~2-week sprints. Each milestone lists key deliverables, dependencies, and exit criteria to keep both Flutter and Laravel workstreams aligned.

## Sprint 0 – Environment & Foundations
- **Deliverables**
  - Repository setup finalized with trunk-based + short-lived feature branches; pre-commit hooks enforcing format/lint/security scans.
  - CI/CD skeletons for Flutter (GitHub Actions + Codemagic) and Laravel (GitHub Actions + Forge/Envoy) running analyze/test on every PR.
  - Base Flutter app (navigation shell, design tokens, localization scaffolding, secure networking configuration) committed.
  - Base Laravel app (Sanctum/JWT auth, health endpoint, request validation middleware, logging stack) committed.
  - Secrets management story defined (environment variable templates + secret manager wiring for dev/staging/prod).
  - Observability stack provisioned (Sentry/Crashlytics projects, Log aggregation destination, Metrics dashboards skeleton).
- **Task Breakdown**
  - _DevOps Lead_: configure GitHub Actions workflows, Dependabot, CodeQL, Android/iOS build pipelines, Docker-based local dev containers.
  - _Flutter Lead_: run `flutter create`, integrate riverpod/go_router/dio, set up flavors (dev/staging/prod), add base theme from `docs/ui_design_system.md`.
  - _Backend Lead_: run `laravel new`, install Sanctum + Spatie Permission, configure Sail or Herd, add health + readiness endpoints, set up Pint/PhpStan.
  - _Security Lead_: define threat model checklist, integrate secret scanning (GitGuardian/trufflehog), configure WAF/rate limiting defaults.
  - _Product/Design_: finalize color/typography tokens in Figma, export Style Dictionary bundle for Flutter consumption.
- **Dependencies**: finalize map provider, OTP provider, storage provider, and hosting region selections.
- **Exit Criteria**: automated tests + linters green on CI; dev/staging environments accessible; critical decision log entries closed with owners.

## Sprint 1 – Identity, Admin, Compatibility (REQ-001, REQ-010, REQ-012, REQ-015)
- **Flutter**: registration/login screens, OTP flow, profile shell, role-aware routing guards.
- **Laravel**: auth APIs, role/permission matrix, admin panel scaffold with user verification.
- **Security**: HTTPS-only configs, input sanitization, file upload policies.
- **Exit Criteria**: users can register/login via mobile; admins can verify accounts; compatibility matrix documented.

## Sprint 2 – Real Estate Core (REQ-002, REQ-003, REQ-004, REQ-005, REQ-013)
- **Flutter**: property search UI (filters, map, cards), property detail view, favorites/share actions, professional directory UI.
- **Laravel**: property CRUD with approval workflow, professional directory endpoints, messaging hooks for inquiries.
- **UX**: responsive layouts and accessibility pass.
- **Exit Criteria**: Approved properties visible/searchable, interactions recorded, consultation requests reach professionals.

## Sprint 3 – Lodging Platform (REQ-006, REQ-007, REQ-017 subset)
- **Flutter**: lodging search (GPS auto locate, amenities filters, map layer), lodging detail page with policies/media, host onboarding forms.
- **Laravel**: lodging models, amenities taxonomy, availability calendar service, media ingestion pipeline, map geocoding service.
- **Exit Criteria**: Hosts can submit facilities for approval with full metadata; guests can discover lodgings via map/text search.

## Sprint 4 – Booking & Communication (REQ-008, REQ-009)
- **Flutter**: booking wizard, confirmation flows, booking management list, in-app chat threads, push notification handling.
- **Laravel**: booking engine (availability validation, cancellation rules), messaging service (WebSocket/Pusher), notification fan-out (Firebase + email).
- **Quality**: widget tests for booking logic, API feature tests for booking/messaging.
- **Exit Criteria**: Users book/cancel stays, chat in real time, receive notifications across channels.

## Sprint 5 – Hardening & Non-Functional (REQ-011, REQ-014, REQ-016, REQ-017 remainder)
- **Performance**: load tests hitting 10k concurrent, caching strategies (Redis, HTTP caching), pagination/perf instrumentation.
- **Reliability**: backup automations, disaster recovery drill, monitoring dashboards, error alerting.
- **Maintainability**: log aggregation, analytics funnel instrumentation, documentation refresh.
- **Exit Criteria**: SLAs validated, backup restore test passed, observability dashboards live, release readiness checklist green.

## Backlog / Future Enhancements (REQ-018)
- **In-app payments**: premium listings, booking deposits; integrate Stripe/Paystack depending on region.
- **Virtual tours**: video hosting, 3D asset streaming.
- **AI recommendations**: property similarity engine leveraging user activity.
- **Advanced admin permissions**: granular RBAC, audit exports.

## Cross-Cutting Workstreams
- **QA Automation**: expand from Sprint 2 onward (Flutter integration tests, Laravel Dusk for admin panel, Postman/Prism contract tests).
- **Design System**: maintain shared components library to keep mobile consistent.
- **Localization Prep**: externalize strings and follow i18n best practices even before multiple languages ship.

## Risk & Mitigation Tracker
| Risk | Impact | Mitigation |
|------|--------|------------|
| Provider delays for OTP/maps | Blocks onboarding + search maps | Secure contracts in Sprint 0, keep abstraction layer to switch providers |
| Media storage costs spike | Budget overrun | Add lifecycle rules, compress media, limit upload sizes |
| Booking concurrency issues | Double-booked lodgings | Use DB transactions + pessimistic locking on availability slots |
| Messaging latency | Poor UX | Evaluate managed Pusher/Ably vs self-hosted WebSockets; include performance SLOs |

Keep this roadmap updated at each sprint review, adjusting scope as dependencies close or new constraints emerge.
