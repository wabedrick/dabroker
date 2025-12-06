# Architecture Overview

This document captures the initial technical design for the combined Real Estate + Lodging platform powered by a Flutter mobile application and a Laravel backend.

## 1. Architecture Goals
- Deliver a unified experience for real estate listings, lodging bookings, and professional services.
- Ensure flexibility for future enhancements (payments, AI recommendations, VR tours).
- Maintain strict security, performance, and uptime targets.
- Keep client and backend loosely coupled through REST (and future GraphQL) APIs.

## 2. System Context
- **Clients**: Flutter mobile app (Android/iOS) consuming JSON APIs; future web admin extensions possible.
- **Backend**: Laravel application exposing REST APIs secured via Sanctum/JWT and serving the admin panel.
- **Data Stores**: Primary relational DB (PostgreSQL preferred), Redis for cache/session, object storage (S3/Cloudinary) for media.
- **External Services**: Maps (Google/Mapbox), SMS/Email provider for OTP, Firebase Cloud Messaging, payment gateway (future).

```
[Flutter App] <--HTTPS--> [Laravel API Layer] <---> [PostgreSQL]
                                   |---> [Redis]
                                   |---> [Object Storage]
                                   |---> [External APIs]
```

## 3. Flutter Application Architecture
- **State Management**: Riverpod/Bloc for predictable state; go_router for navigation.
- **Layers**:
  - Presentation: feature-specific UI modules (Authentication, Real Estate, Lodging, Professionals, Messaging, Profile, Settings).
  - Application: controllers/use-cases coordinating repositories.
  - Data: repository interfaces, API clients, local persistence (Hive/SQLite) for caching.
- **Key Components**:
  - Map module abstracting provider SDK.
  - Media uploader supporting queued uploads + retries.
  - Messaging module integrating with real-time service (WebSocket/Pusher).
  - Booking experience with calendar widgets and review flows.
- **Platform Services**: location permissions, push notifications via Firebase Messaging, background sync for saved searches.

## 4. Laravel Backend Architecture
- **Modules** (Domain-oriented):
  - Auth & Identity (Sanctum/JWT, OTP, role management).
  - Listings (properties, media, approvals).
  - Lodging (facilities, availability calendar, bookings, reviews).
  - Professionals (directory, consultations).
  - Messaging (real-time channels, notifications bridge).
  - Admin Panel (moderation, analytics, reporting).
  - Support Services (search, geocoding, file management).
- **Layering**:
  - Controllers -> Services -> Repositories (Eloquent models) -> Database.
  - Events/Listeners for async notifications.
  - Jobs/Queues (Redis) for heavy tasks: media processing, notification fan-out, report generation.
- **APIs**:
  - Versioned `/api/v1/...` endpoints returning JSON API responses.
  - Admin routes served via Laravel Nova/Filament or custom Blade/Vue interface.
- **Search & Filtering**:
  - Combine DB querying with optional ElasticSearch/OpenSearch later.
  - Geospatial queries via PostGIS or Haversine calculations for near-term MVP.

## 5. Data Model Snapshot
- **Users**: roles (buyer, seller, host, professional, admin). Additional tables for professional profiles, verification documents.
- **Properties**: type, category, pricing, metadata, media, approval status, geolocation.
- **Lodgings**: facility details, amenities, pricing matrices, availability calendar, policies.
- **Bookings**: user, lodging, status, payment placeholder, cancellation rules, reviews.
- **Messages**: conversation, participants, message body, attachments.
- **Consultations**: professional, user, scheduled time, outcomes.
- **Audit/Logs**: track admin actions, verification history.

## 6. Integrations & Communication
- **Map Provider**: abstraction service selects Google/Mapbox based on config.
- **OTP Provider**: queue-driven SMS/email delivery with fallback/resend logic.
- **Push Notifications**: Laravel events trigger Firebase messaging topics (per user, per conversation).
- **Email**: Laravel Mailables for confirmations, booking receipts, admin alerts.
- **Real-time Messaging**: Laravel WebSockets or Pusher; Flutter listens via WebSocket streams.

## 7. Security & Compliance
- Enforce HTTPS, HSTS, secure TLS ciphers; terminate TLS at load balancer with automatic certificate rotation.
- Input validation via Laravel Form Requests + Flutter client-side guards, backed by centralized validation schemas shared across platforms.
- Role-based middleware protecting APIs; sensitive actions double-gated via policies and explicit permission scopes.
- File uploads scanned (size/type) and stored with signed URLs; media served via short-lived pre-signed URLs only.
- Apply rate limiting, bot detection, and WAF rules on public endpoints.
- Encrypt sensitive data at rest (database column encryption for PII, KMS-managed keys for storage buckets).
- Audit logs for admin actions, booking changes, and property approvals streamed to immutable storage.
- Secrets handled via environment variables + secrets manager (Azure Key Vault/AWS Secrets Manager) with rotation playbooks.
- Security assurance pipeline: dependency scanning (Dependabot, npm audit, Composer audit), SAST, DAST, and periodic penetration tests.

## 8. Deployment & DevOps
- **Environments**: local, staging, production with isolated resources.
- **CI/CD**:
  - Backend: GitHub Actions running PHPUnit, Pint, Laravel Dusk, deploying via Envoy/Forge.
  - Flutter: GitHub Actions + Codemagic for build/test, distributing via Firebase App Distribution/TestFlight.
- **Monitoring**: Laravel Telescope + centralized logging (ELK/OpenSearch), mobile crash analytics (Sentry/Crashlytics).
- **Backups**: automated DB dumps + object storage lifecycle policies; periodic restore drills.

## 9. Performance & Scalability Strategy
- **API Efficiency**: paginate by default, support cursor-based pagination for feeds, expose filter indexes, and compress payloads (gzip/brotli).
- **Caching Layers**: Redis for query caching + session storage, HTTP cache headers for CDN edge caching, client-side caching with ETags.
- **Async Workloads**: offload heavy tasks (media processing, notification fan-out, analytics) to queues; use Horizon for monitoring.
- **Database Health**: employ read replicas, partition high-volume tables (messages, logs), and add PostGIS indexes for geo queries.
- **Mobile Performance**: leverage Flutter's `const` widgets, selective rebuilds via Riverpod, image lazy-loading, and precaching of hero assets.
- **Observability**: define performance budgets (API p95 < 3s, UI interaction < 100ms) and alert when SLOs drift.

## 10. Responsive UI & Theming Strategy
- **Design Tokens**: maintain shared JSON tokens (colors, spacing, typography) feeding Flutter theme extensions and admin panel styles.
- **Color System**: primary (deep emerald), secondary (warm amber), neutral grays, semantic success/warning/error palettes with WCAG AA contrast.
- **Adaptive Layouts**: implement breakpoints (<=360dp compact, 361-600 standard, >600 expanded) to rearrange grids/cards; support landscape tablet views for agents.
- **Component Library**: build reusable widgets (property cards, booking sheets, chat bubbles) in a dedicated Flutter package with snapshot tests.
- **Motion Guidelines**: keep animations under 300ms, provide reduced-motion toggles, and prefer easing curves aligned with Material 3 best practices.
- **Accessibility**: dynamic font sizing, semantic labels, keyboard navigation support for admin panel, high-contrast and dark mode themes.

## 11. Inquiry & Notification APIs
- **Owner inquiry listing**: `/api/v1/owner/inquiries` paginates every inquiry for the authenticated seller with optional `status`, `property_id`, and `unread_only` filters. Responses use `PropertyInquiryResource`, which now also bundles the latest message thread when eager loaded.
- **Inquiry detail + read receipts**: `/api/v1/owner/inquiries/{inquiryId}` hydrates a single record, stamps `read_at` for the owner automatically, and exposes both `read_at` (owner) and `buyer_read_at` (sender) so the UI can show who has seen the conversation. `/api/v1/inquiries/{inquiryId}/read` is shared by both buyer and owner for explicit acks (batch flows, mark-all-read buttons, etc.).
- **Conversation replies**: `/api/v1/inquiries/{inquiryId}/messages` accepts auth’d buyers or owners and appends to `property_inquiry_messages`. Every message is emitted through `PropertyInquiryMessageResource`, including the sender capsule and optional metadata payload so Flutter can render maps/files inline.
- **Buyer contact flow**: `/api/v1/properties/{propertyId}/contact` still drives initial outreach, but now only approved listings are accepted and attempts to message your own listing fail fast with a 422. The initial buyer note seeds both the inquiry and the first message record so downstream UIs stay consistent.
- **Reply notifications**: `PropertyInquiryReplyNotification` fans out via database + optional email channels (respecting `/api/v1/notifications/preferences` toggles). Owners replying resets `buyer_read_at` so buyers accrue `buyer_unread_inquiries`, and vice versa, ensuring badge counts stay accurate.
- **Realtime message events**: every new reply triggers `PropertyInquiryMessageCreated`, a broadcast over `private-users.{ownerId}` and `private-users.{buyerId}`. The payload contains the updated read receipts and the normalized message so clients can hydrate threads instantly without hitting the REST endpoint. The same preference-controlled notification now emits on the `broadcast` channel for lightweight badge nudges.
- **Notification preferences**: `/api/v1/notifications/preferences` (GET/PUT) lets any authenticated user toggle push/email channels for inquiry + favorite alerts. Defaults favor push for both, email for inquiries only, and we call `notificationPreference()` inside the notification classes to honor the stored config.
- **Counters + badges**: `/api/v1/notifications/counters` now surfaces `unread_inquiries`, `buyer_unread_inquiries` (buyers waiting on an owner reply), `unread_favorites` (buyers who saved your listings but you have not acknowledged), and `saved_favorites` (your personal watchlist size). `/api/v1/notifications/favorites/acknowledge` and `/api/v1/inquiries/{inquiryId}/read` keep badges tidy.

## 12. Flutter Integration Notes (Inquiries & Notifications)
- **Data layer**: add repository endpoints for `/owner/inquiries`, `/inquiries/{id}/messages`, `/inquiries/{id}/read`, `/notifications/counters`, and favorites/interest routes. Reuse the existing Dio client with Sanctum interceptors, hydrate message payloads with `PropertyInquiryMessageResource` fields, and cache counters locally (Hive) so badges render instantly while background refresh runs.
- **State management**: dedicate Riverpod providers for `InquiryFeedState`, `ConversationState`, and `NotificationBadgeState`. Providers should expose `markRead` (`read_at` vs `buyer_read_at`) actions that optimistically toggle both owner + buyer read flags before awaiting API confirmation, sync notification-preference mutations locally, and reconcile websocket payloads without double-appending messages.
- **UI flows**: sellers get a Messages tab listing inquiries grouped by property; tapping an item pushes a chat-style detail sheet seeded with the full message thread and read receipts. Badge counts on the tab, buyer inbox, and Favorites Insights card bind to `/notifications/counters` (including the new `buyer_unread_inquiries`). Conversation screens should watch the `PropertyInquiryMessageCreated` stream so replies appear in real time.
- **Realtime bridge**: authenticate Pusher/Laravel Echo against `private-users.{currentUserId}` and listen for both `property-inquiry.message-created` and `Illuminate\Notifications\Events\BroadcastNotificationCreated`. The former hydrates chat bubbles; the latter bumps badges/snackbars using the broadcast notification payload. When the app is backgrounded, mirror these events through FCM/APNs using the same payload fields.
- **Flutter Echo wiring**: use `laravel_echo` + `pusher_client` (or Ably/websockets client) to connect with the Sanctum token injected into the authorizer header. Example:
  ```dart
  final echo = Echo(
    broadcaster: EchoBroadcasterType.pusher,
    client: PusherClient(
      env.pusherKey,
      PusherOptions(cluster: env.pusherCluster, encrypted: true, auth: PusherAuth(
        '${env.apiBase}/broadcasting/auth',
        headers: {'Authorization': 'Bearer $sanctumToken'},
      )),
    ),
  );

  echo.private('users.${user.id}')
    .listen('property-inquiry.message-created', (payload) => conversationProvider.add(payload))
    .notification((data) => badgeProvider.bump(data));
  ```
  Tear the socket down during logout and resubscribe after token refreshes.
- **Background sync**: schedule a silent push or periodic background task to call `/notifications/counters` so badges stay fresh even when the app is minimized. Tie push payloads to the inquiry ID so the client knows whether to refresh the inbox, conversation thread, or interested-buyer list, and respect user preferences by skipping channels they disabled.
- **Error handling**: show actionable toasts for 403/422 responses (e.g., contacting own listing or third parties trying to reply). Retry logic should degrade to queued mutations when offline and replay once connectivity returns, replaying pending messages in order.

## 13. Open Questions
- Final decision on map provider and pricing model.
- Choice between WebSockets self-hosting vs managed Pusher/Ably.
- Need for multi-language from day one or later release.
- Payment gateway priorities for premium listings vs booking deposits.
