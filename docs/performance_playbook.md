# Performance Playbook

Guidelines, budgets, and tooling to keep the Broker platform responsive from client to backend.

## 1. Budgets & KPIs
| Layer | Metric | Target |
|-------|--------|--------|
| Mobile UI | First interactive screen | < 1.5s on mid-tier Android (Pixel 5) |
| Mobile UI | Frame build/raster time | < 8ms build, < 12ms raster (60fps) |
| API | P50 latency | < 600ms |
| API | P95 latency | < 3s |
| Search Queries | Response size | < 200KB compressed |
| Booking Flow | End-to-end completion | < 4s (excluding network) |
| Push Notifications | Delivery latency | < 5s |

## 2. Flutter Optimization Strategy
- **State Management**: use `riverpod`/`hooks_riverpod` with granular providers to avoid rebuilding entire widget trees.
- **Networking**: `dio` with interceptors for gzip compression, request deduping, and offline cache (etag-based).
- **Rendering**: favor `const` constructors, avoid opacity layers, use `RepaintBoundary` for maps/carousels.
- **Images**: integrate `cached_network_image` with low/high-res placeholders and precache hero images.
- **Performance Tooling**:
  - Flutter DevTools for frame analysis; budget dashboards saved per feature.
  - `flutter drive` integration tests measuring timeline events with performance assertions.
  - Firebase Performance Monitoring for real-world metrics.

## 3. Backend Optimization Strategy
- **Database**: normalized schema with selective denormalization (materialized views for featured listings). Add indexes for filters (price, type, geo) and use PostGIS for spatial queries.
- **Caching**: Redis-backed query caching, response caching via HTTP cache headers + CDN, Laravel cache tags for invalidation.
- **Async Processing**: queues for media processing, notifications, heavy analytics; Horizon monitors throughput.
- **API Contracts**: support pagination (cursor-based), filtering, sparse fieldsets. Enforce `?fields=` parameter to limit payloads.
- **Profiling Tools**: Laravel Telescope, Blackfire, New Relic/Datadog APM for hot path detection.

## 4. Testing & Automation
- Integrate load tests (k6/Artillery) into CI nightly; gate merges if latency budgets regress >10%.
- Use contract tests with mocked latency to ensure client gracefully handles slow endpoints.
- Run Flutter integration benchmarks on physical devices (Firebase Test Lab) each release candidate.
- Establish synthetic monitoring hitting key APIs + booking flow every 5 minutes.

## 5. Capacity Planning
- Autoscale application servers based on CPU+latency; maintain 30% headroom.
- Database read replicas for analytics/reporting; failover tested quarterly.
- Redis cluster sized for peak QPS with persistence disabled for cache layer to maximize throughput.

## 6. Performance Review Cadence
- Weekly performance triage reviewing dashboards (APM, Firebase, Crashlytics ANR reports).
- Include performance sign-off in definition of done for every epic.
- Document regressions + remediation in performance log.

Adhering to this playbook ensures performance remains a core deliverable alongside functionality.
