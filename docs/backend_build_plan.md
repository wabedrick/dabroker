# Backend Build Plan

Backend development will proceed in phases, focusing on secure, production-grade APIs before the Flutter client consumes them.

## Phase 1 – Identity & Access
- Sanctum token auth, password hashing (Argon2id), rate-limited login/register.
- OTP service integration (abstracted service for SMS/email providers).
- Profile endpoints (view/update, upload verification docs via MediaLibrary).
- Role assignment & guards using `spatie/laravel-permission`.
- Session/device management endpoints.
- Admin verification workflow for new users.

## Phase 2 – Real Estate Listings
- Property CRUD (owners) with approval workflow (admin endpoints).
- Listing search/filter endpoints with Scout + pagination & bounding box queries.
- Favorites, sharing links, contact owner endpoint triggering messaging channel.
- Media handling (images, documents) with validation + transformation queue jobs.

### Phase 2 Execution Blueprint (Real Estate Listings)
- **Domain Objects**: `Property` model (status enum, owner + approver relationships), amenity metadata, media collections for gallery/docs, approval audit fields.
- **APIs**:
	- Public: `GET /api/v1/properties` (filters: q, type, price range, city/state/country, status=approved only), `GET /api/v1/properties/{public_id}`.
	- Owner: `GET/POST/PATCH/DELETE /api/v1/owner/properties` routed through policies, support draft/pending states, restrict destructive actions once approved.
	- Admin: `POST /api/v1/admin/properties/{public_id}/approve|reject` to finalize workflow + emit events.
- **Workflows**:
	- Creation auto-sets `status=pending`, triggers notification to reviewers.
	- Approval sets `approved_at/by`, indexes record via Scout, notifies owner.
	- Rejection records reason + optional remediation checklist back to owner; listing remains hidden from public catalog.
- **Validations**: strict enum validation, decimal precision on price/size, lat/long bounds, amenities array whitelist, max media count enforced server-side + queued conversions.
- **Testing Matrix**: feature tests covering owner CRUD, policy enforcement, admin approval/rejection, public search filters, and Scout-backed keyword queries; factory seeds w/ assorted statuses.
- **Milestones**:
	1. Domain scaffolding (migration, model, factory, policy) ✅
	2. Owner CRUD + approval endpoints (current sprint)
	3. Search/filter endpoints + Scout index gating (current sprint)
	4. Media upload contracts + queue jobs (next sprint)

## Phase 3 – Professionals & Consultations
- Professional directory models, verification, availability slots.
- Consultation scheduling endpoints + notifications to both parties.
- Integration with messaging module for consultation threads.

## Phase 4 – Lodging & Booking
- Lodging models (amenities, policies) and host-facing CRUD.
- Availability calendar service (per-night/per-block granularity).
- Booking engine (create, hold, confirm, cancel) with concurrency control.
- Reviews/ratings pipeline and moderation hooks.

## Phase 5 – Messaging & Notifications
- Real-time conversations (WebSockets/Pusher fallback) with message persistence.
- Push/email notifications via Firebase + Laravel Mail.
- Spam/threat detection hooks, reporting endpoints.

## Phase 6 – Admin & Analytics
- Admin panel APIs (user moderation, listing approvals, booking oversight).
- Analytics/reporting endpoints with caching.
- Activity log exports and audit trails.

## Phase 7 – Non-Functional Hardening
- Performance optimization (caching, queue scaling, database indexing).
- Security audits (pen-test findings, rate limit tuning, WAF rules).
- Observability dashboards, alerting, backup/restore drills.

Each phase has acceptance criteria in `requirements_tracker.md`. We'll mark requirements as 🟡/🟢 as APIs and tests land.

## Progress Tracker (updated 2025-11-22)
- [x] Phase 1 – Identity & Access: Sanctum auth, OTP service, password reset, and profile endpoints implemented in `backend/api/app/Http/Controllers/API/AuthController.php` with coverage in `tests/Feature/Auth/AuthTest.php`.
- [ ] Phase 2 – Real Estate Listings: owner CRUD + approval workflow + public browse/search + gallery uploads live (`OwnerPropertyController`, `PropertyBrowseController`, `OwnerPropertyMediaController`, feature tests under `tests/Feature/Property`). Remaining scope: favorites, admin dashboards, and contact/follow-up flows.
- [ ] Phase 3 – Professionals & Consultations: pending.
- [ ] Phase 4 – Lodging & Booking: pending.
- [ ] Phase 5 – Messaging & Notifications: pending.
- [ ] Phase 6 – Admin & Analytics: pending.
- [ ] Phase 7 – Non-Functional Hardening: ongoing by sprint.
