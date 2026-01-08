# Project Requirements Tracker

Use this document to capture every requirement for the Flutter client and Laravel backend, track implementation status, and confirm completion before release.

## Quick Start Checklist
- [ ] Requirement captured with clear description, acceptance criteria, and platform (Flutter, Laravel, or Both)
- [ ] Technical notes (APIs, models, UI widgets, migrations) documented
- [ ] Testing plan recorded (unit, widget, feature, API)
- [ ] Requirement assigned and target milestone defined
- [ ] Status updated to `Done` only after development + tests pass and code merged

## Requirement Log
Fill one table row per requirement. Duplicate the placeholder row for new entries.

| ID | Feature / Requirement | Platform | Acceptance Criteria | Status | Owner | Target Milestone | Notes / Links |
|----|-----------------------|----------|---------------------|--------|-------|------------------|---------------|
| REQ-001 | Authentication & user management | Both | Email/phone sign-up, OTP verify, password reset, role-aware profiles, Sanctum/JWT tokens issued to mobile apps | 🟢 Done | Backend | Sprint 1 | Backend auth + OTP flows implemented (`AuthController`, `OtpService`, `routes/api.php`), feature tests passing (`tests/Feature/Auth/AuthTest.php`). Frontend integration pending |
| REQ-002 | Real estate property search | Both | Search by type, price, location (map/text), age/category, keyword; detail screen renders media + metadata | 🟢 Done | Backend + Flutter | Sprint 1 | Map View added using flutter_map. Search & Filters implemented. |
| REQ-003 | Property registration & management | Both | Owners upload media/docs, set price/size/location, select category/condition, submit for approval, edit/delete while pending or live | 🟡 In Progress | Backend | Sprint 2 | Owner CRUD, approvals, and gallery upload endpoints live; admin panel + buyer interactions pending |
| REQ-004 | Professional consultation services | Both | Directory lists brokers/surveyors/lawyers, users can message and schedule consultations with audit trail | 🟡 In Progress | TBD | Sprint 2 | Directory, Profiles, Reviews, Portfolio implemented. Messaging/Scheduling pending. |
| REQ-005 | Property interaction tools | Both | Users save favorites, share listings, and contact owners via in-app chat or provided phone/email | 🔲 Not Started | TBD | Sprint 2 | Requires REQ-009 messaging + push notifications |
| REQ-006 | Lodging search & discovery | Both | GPS auto-location, filters (type, price, amenities), map markers, detail page captures rules/policies/media | 🔲 Not Started | TBD | Sprint 3 | Needs location permissions + map rendering |
| REQ-007 | Lodging registration & availability | Both | Hosts enter facility data, upload media/docs, set rules, manage availability calendar, set lat/long manually or via GPS | 🔲 Not Started | TBD | Sprint 3 | Calendar component shared with booking engine |
| REQ-008 | Booking system | Both | Users view availability, create/cancel bookings, receive confirmations, rate & review stays | 🔲 Not Started | TBD | Sprint 4 | Payment hooks reserved for future premium deposits |
| REQ-009 | Communication & notifications | Both | Real-time messaging (owner↔user, user↔professional), push notifications via Firebase, email alerts via Laravel Mail | 🔲 Not Started | TBD | Sprint 4 | Evaluate WebSocket vs Pusher for realtime |
| REQ-010 | Admin dashboard & moderation | Laravel | Admins verify users/listings, approve/reject posts, moderate media, manage users, view analytics/reports | 🟢 Done | Backend + Flutter | Sprint 1 | Laravel admin routes/controllers, analytics + moderation logs + user updates completed (`routes/api.php`, `Admin*Controller`, tests). Flutter admin dashboard + moderation UI live (`lib/features/admin/...`). |
| REQ-011 | Performance & scalability | Both | API p95 < 3s, load tests for 10k concurrent users, cache via Redis, pagination across listings | 🔲 Not Started | TBD | Sprint 5 | Requires perf test plan + infra budget |
| REQ-012 | Security & compliance | Both | HTTPS enforced, sanitized inputs, role-based API guards, file type/size validation for uploads | 🔲 Not Started | TBD | Sprint 1 | Include automated security scans |
| REQ-013 | Usability & responsiveness | Flutter | UI adapts to phone/tablet, intuitive navigation, prep for future multilingual copy | 🔲 Not Started | TBD | Sprint 2 | Coordinate with design system tokens |
| REQ-014 | Availability & backups | Laravel | 99.5% uptime target, automated daily DB/media backups with restore runbooks | 🔲 Not Started | TBD | Sprint 5 | Uses hosting provider backup tooling |
| REQ-015 | Compatibility targets | Both | Mobile builds run on Android 8+/iOS 13+, admin panel supports Chrome/Firefox/Safari/Edge | 🔲 Not Started | TBD | Sprint 1 | QA matrix to be documented |
| REQ-016 | Maintainability & observability | Laravel | Modular service boundaries, structured logging, analytics tracking for key funnels | 🔲 Not Started | TBD | Sprint 5 | Select logging stack (e.g., Laravel Telescope + ELK) |
| REQ-017 | External integrations | Both | Google Maps/Mapbox, SMS/email OTP provider, S3/Cloudinary storage, PostgreSQL/MySQL + Redis, payment gateway hooks | 🔲 Not Started | TBD | Sprint 3 | Capture API keys/secrets management plan |
| REQ-018 | Future enhancements backlog | Both | In-app payments, virtual tours, AI recommendations, advanced admin permissions captured in roadmap | 🔲 Not Started | TBD | Backlog | Requires product prioritization workshop |

**Status Legend**
- 🔲 Not Started
- 🟡 In Progress
- 🟢 Done (code merged, tests pass)
- 🔴 Blocked (note blocker in Notes column)

## Platform-Specific Kanban

### Flutter App
- **Backlog**: REQ-001 auth UI, REQ-002 property search UI, REQ-005 interaction widgets, REQ-006 lodging discovery, REQ-008 booking flows, REQ-009 chat & notifications, REQ-013 responsive layout, REQ-017 map integration shell
- **In Progress**: _None_
- **Ready for QA**: _None_
- **Done**: _None_

### Laravel Backend
- **Backlog**: REQ-001 auth APIs, REQ-003 property CRUD, REQ-004 professional services, REQ-007 lodging admin, REQ-008 booking engine, REQ-009 messaging service, REQ-011 performance/caching, REQ-012 security hardening, REQ-014 backups, REQ-016 observability, REQ-017 integrations, REQ-018 roadmap features
- **In Progress**: _None_
- **Ready for QA**: _None_
- **Done**: REQ-010 admin dashboard & moderation

## Acceptance Criteria Template
Copy/paste when defining new requirements.

```
### Requirement Title (ID)
- **User Story**: As a <role>, I want <feature> so that <value>.
- **Platforms**: Flutter / Laravel / Both
- **Acceptance Criteria**:
  1. 
  2. 
  3. 
- **Technical Notes**: data models, API endpoints, migrations, widgets, services, validation, etc.
- **Testing**: unit, integration, widget, feature, API, manual scenarios.
- **Dependencies**: list upstream items or blockers.
- **Verification**: link to QA checklist or test run.
```

## Decision & Dependency Log
Track cross-team decisions, API contracts, or infra needs.

| Date | Decision / Dependency | Impact | Owner | Follow-up |
| 2025-11-22 | Select maps provider (Google Maps vs Mapbox) | Determines SDK integration effort and pricing for REQ-002/006/017 | Product + Engineering | Compare cost + offline support, decide by Sprint 1 planning |
| 2025-11-22 | OTP + messaging provider (SMS/email) | Blocks REQ-001 verification + notifications | Backend Lead | Evaluate Twilio vs AWS SNS; confirm throughput and regional coverage |
| 2025-11-22 | Cloud storage strategy (S3 vs Cloudinary) | Needed for REQ-003/007 media uploads and backup policy REQ-014 | Infrastructure | Prototype upload flows, confirm compliance requirements |

## Release Readiness Checklist
- [ ] All requirements marked 🟢 Done with QA sign-off
- [ ] Regression tests executed for Flutter and Laravel
- [ ] API documentation updated
- [ ] Deployment plan reviewed (backend migrations, Flutter build configs)
- [ ] Rollback plan documented

Keep this tracker updated as requirements arrive so nothing slips through the cracks.
