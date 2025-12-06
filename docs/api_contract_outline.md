# API Contract Outline

High-level endpoint map to guide backend-first development and unblock Flutter integration. Detailed OpenAPI specs will extend these modules.

## 1. Auth & Identity (REQ-001)
| Endpoint | Method | Description | Notes |
|----------|--------|-------------|-------|
| `/api/v1/auth/register` | POST | Register buyer/seller/host/professional with email/phone, password, OTP challenge | Validate phone/email uniqueness, queue OTP delivery |
| `/api/v1/auth/verify-otp` | POST | Confirm OTP for registration or sensitive action | Include attempt throttling |
| `/api/v1/auth/login` | POST | Issue Sanctum/JWT tokens; return user roles + permissions | Support email/password + phone/password |
| `/api/v1/auth/logout` | POST | Revoke tokens | Logout all sessions optionally |
| `/api/v1/auth/password/forgot` | POST | Send reset token/OTP | |
| `/api/v1/auth/password/reset` | POST | Complete reset | |
| `/api/v1/profile` | GET/PUT | View/update profile + KYC docs | File uploads handled via media library |

## 2. Properties (REQ-002, REQ-003, REQ-005)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/properties` | GET | Paginated search with filters (type, price, location, age, keyword) + map bounding-box support |
| `/api/v1/properties/{id}` | GET | Property detail with media, owner info, approvals |
| `/api/v1/properties` | POST | Create property listing (owner role) -> pending approval |
| `/api/v1/properties/{id}` | PUT/PATCH | Update pending/approved listings respecting workflow |
| `/api/v1/properties/{id}` | DELETE | Soft delete listing |
| `/api/v1/properties/{id}/favorite` | POST/DELETE | Save/unsave listing |
| `/api/v1/properties/{id}/share` | POST | Generate shareable deep link |
| `/api/v1/properties/{id}/contact` | POST | Initiate message thread with owner |

## 3. Professionals & Consultations (REQ-004)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/professionals` | GET | Directory search (type, location, rating) |
| `/api/v1/professionals/{id}` | GET | Profile details, certifications |
| `/api/v1/professionals/{id}/consultations` | POST | Request consultation slot |
| `/api/v1/consultations/{id}` | PATCH | Update status (confirmed, completed, cancelled) |

## 4. Lodging & Booking (REQ-006, REQ-007, REQ-008)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/lodgings` | GET | Search by GPS, type, price, amenities, availability window |
| `/api/v1/lodgings/{id}` | GET | Detail view (policies, media, availability) |
| `/api/v1/lodgings` | POST | Host submits facility for approval |
| `/api/v1/lodgings/{id}/availability` | PUT | Manage calendar slots |
| `/api/v1/bookings` | POST | Create booking (validate availability, hold slot) |
| `/api/v1/bookings/{id}` | GET | Booking detail |
| `/api/v1/bookings/{id}` | PATCH | Update/cancel booking |
| `/api/v1/bookings/{id}/reviews` | POST | Submit rating + review |

## 5. Messaging & Notifications (REQ-009)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/conversations` | GET | List user conversations |
| `/api/v1/conversations/{id}/messages` | GET | Paginated messages |
| `/api/v1/conversations/{id}/messages` | POST | Send message (text/media) |
| `/api/v1/notifications/register-device` | POST | Register FCM token |
| `/api/v1/notifications/preferences` | PUT | Opt-in/out of channels |

## 6. Admin Panel APIs (REQ-010)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/admin/users` | GET | Filter users by role/status |
| `/api/v1/admin/users/{id}/verify` | POST | Approve identity/role |
| `/api/v1/admin/listings` | GET | Moderation queue |
| `/api/v1/admin/listings/{id}/approve` | POST | Approve/reject listing with reason |
| `/api/v1/admin/reports/kpis` | GET | Analytics summary |
| `/api/v1/admin/audit-log` | GET | Activity logs |

## 7. System & Utility
- `/api/v1/health` – liveness
- `/api/v1/ready` – readiness (DB/cache/external services)
- `/api/v1/config` – fetch feature flags, supported filters for mobile bootstrapping

## 8. Standards
- All endpoints versioned under `/api/v1/` with JSON:API-like envelope `{ data, meta, links }`.
- Auth via Sanctum token header `Authorization: Bearer {token}`.
- Pagination: cursor-based (`page[cursor]`) for feeds; fallback to `page[number]` where needed.
- Errors follow RFC 7807 (Problem Details) with trace IDs for correlation.

## 9. Next Steps
1. Convert outline into full OpenAPI spec (Stoplight/Swagger) with schemas.
2. Align with Flutter team to confirm payloads, field naming, and error handling.
3. Implement module-by-module starting with Auth + Properties per roadmap.
