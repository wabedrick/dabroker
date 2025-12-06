# Security Threat Model

This document identifies key assets, attack surfaces, threats, and mitigations for the Broker platform.

## 1. Assets & Trust Boundaries
- **User Data**: personal profiles, identification documents, booking history.
- **Listings & Media**: property photos, ownership documents.
- **Credentials & Tokens**: JWT/Sanctum tokens, refresh tokens, OTP codes.
- **Payments & Future Premium Data**: deposit records (future feature).
- **Admin Actions**: approvals, moderation notes.
- **Infrastructure Secrets**: API keys (maps, OTP), database credentials.

Trust boundaries exist between client devices, public APIs, internal services (queues, DB), third-party providers, and admin interfaces.

## 2. Attack Surface Overview
| Surface | Description | Threat Examples |
|---------|-------------|-----------------|
| Mobile App | Flutter client interacting via HTTPS | Reverse engineering, MITM, token theft |
| API Gateway | Laravel HTTP endpoints | Injection, auth bypass, brute force, rate abuse |
| Media Uploads | File ingestion via mobile/admin | Malware uploads, oversized payloads |
| Messaging/Realtime | WebSocket/Pusher channels | Unauthorized conversation access, spam |
| Admin Panel | Laravel Nova/Filament UI | Privilege escalation, session hijack |
| Third-Party APIs | Maps, OTP, storage, notifications | Credential leakage, quota exhaustion |

## 3. Threat Scenarios & Mitigations

### 3.1 Account Takeover
- **Threat**: attackers brute force credentials or intercept OTP codes.
- **Mitigations**:
  - Enforce rate limiting + IP/device fingerprinting on auth endpoints.
  - Require MFA (OTP) with short-lived codes and lockouts after failed attempts.
  - Use push-based verification for high-risk actions (e.g., listing approvals).
  - Store hashed passwords with Argon2id; rotate refresh tokens on sign-in.

### 3.2 API Abuse & Data Exfiltration
- **Threat**: bots scrape listings or exploit insecure endpoints.
- **Mitigations**:
  - Implement API gateway/WAF (Cloudflare/Azure Front Door) with bot filtering and anomaly detection.
  - Require OAuth-style scopes per role; enforce least privilege via Spatie Permission.
  - Monitor unusual query volumes; throttle per IP/user/token.
  - Return only necessary fields (sparse fieldsets) and encrypt sensitive notes.

### 3.3 Media Upload Malware
- **Threat**: malicious documents/images uploaded to backend.
- **Mitigations**:
  - Validate MIME + extension + size before upload; reject unsupported types.
  - Scan files using antivirus service (ClamAV/Lambda AV) before making public.
  - Store media in private buckets; serve via signed URLs with short TTLs.
  - Strip EXIF metadata to prevent geo leaks.

### 3.4 Injection & Deserialization
- **Threat**: SQL injection, command injection, mass assignment.
- **Mitigations**:
  - Use Eloquent parameter binding + query builder; disable mass assignment by default.
  - Centralize request validation; sanitize user input at edges.
  - Run static analysis (Larastan, PHPStan) + security linters on CI.

### 3.5 Messaging Abuse & Spam
- **Threat**: attackers send spam/scams via messaging channel.
- **Mitigations**:
  - Require verified accounts before messaging; rate limit message sends.
  - Content moderation pipeline (keyword filters, ML scoring) to flag suspicious content.
  - Provide reporting tools; blocklist abusive accounts/devices.

### 3.6 Admin Privilege Escalation
- **Threat**: compromised admin account used to approve fraudulent listings.
- **Mitigations**:
  - Enforce SSO/MFA for admins; restrict admin panel to corporate IPs/VPN.
  - Maintain immutable audit logs & alerts for admin role changes.
  - Dual-control approvals for high-value listings.

### 3.7 Supply Chain & Dependency Risks
- **Threat**: vulnerable packages or tampered dependencies.
- **Mitigations**:
  - Lock dependencies with checksums; use Dependabot + Renovate updates.
  - Scan builds with SCA (Snyk, Trivy) and verify Flutter artifacts before release.
  - Use reproducible builds and sign mobile binaries (Play/App Store signing).

### 3.8 Infrastructure Compromise
- **Threat**: unauthorized access to servers, storage, or CI secrets.
- **Mitigations**:
  - Use least-privilege IAM roles; rotate keys regularly.
  - Restrict SSH via bastion + short-lived certificates; prefer managed services (Laravel Vapor/Forge).
  - Encrypt backups; store keys in KMS; audit secret access logs.

## 4. Detection & Response
- Centralized logging (ELK/OpenSearch) with alerting on auth anomalies, rate-limit exceedances, admin actions.
- Use SIEM (Azure Sentinel/Datadog) to correlate signals; define incident runbooks.
- Regular chaos/security drills (credential leak simulation, backup restore, failover test).

## 5. Security Requirements Checklist
- [ ] Threat model reviewed each release cycle.
- [ ] Penetration test conducted pre-launch and annually.
- [ ] All secrets stored in managed secret vault; no plaintext in repos/CI logs.
- [ ] Dependency updates triaged weekly; critical CVEs patched within 24h.
- [ ] Device and session management for users (session revocation, device list).
- [ ] Data retention + deletion policies documented per privacy laws.

Keeping this threat model updated ensures security stays central throughout development.
