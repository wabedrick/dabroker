# Broker Flutter App

This folder will host the Flutter client delivering the real estate + lodging experience.

## Setup Checklist
- Flutter SDK 3.24+ with FVM (recommended) for version pinning.
- Platforms: Android SDK 34, Xcode 16 toolchain, Chrome for web debugging (optional).
- Packages to integrate early: `flutter_riverpod`, `go_router`, `dio`, `freezed`, `json_serializable`, `firebase_messaging`, `google_maps_flutter`/`mapbox_gl`, `web_socket_channel`.
- Shared design system imported via a local package (`packages/broker_design_system`).

## Security & Performance Guardrails
- Enable code obfuscation/minify for release builds; use `flutter build apk --obfuscate --split-debug-info=...`.
- Enforce HTTPS-only networking via `dio` interceptors and OS network security configs.
- Instrument performance with `Firebase Performance` + `Sentry` for frame drops and ANRs.
- Add widget/integration tests for every critical flow (auth, search, booking, messaging).

## Build Commands
```bash
# analyze + format
flutter analyze
flutter test

# run with flavor (dev/staging/prod)
flutter run --flavor dev -t lib/main_dev.dart
```

Follow `docs/ui_design_system.md` and `docs/quality_principles.md` when implementing new screens.
