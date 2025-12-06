# UI Design System

This guide ensures the Flutter experience is professional, responsive, secure, and visually consistent across devices.

## 1. Brand Foundations
- **Brand Voice**: trustworthy, premium, and approachable for both investors and travelers.
- **Core Themes**: modern real-estate sophistication blended with warm hospitality cues.

## 2. Color Palette
| Role | Name | Hex | Usage |
|------|------|-----|-------|
| Primary 500 | Emerald Rise | #0B8A6E | Buttons, highlights, map pins (selected) |
| Primary 700 | Deep Canopy | #06604D | App bars, active states |
| Secondary 500 | Amber Dawn | #F5A524 | Callouts, accent chips |
| Neutral 900 | Midnight Slate | #1F2428 | Primary text |
| Neutral 600 | Graphite Mist | #4A545E | Secondary text |
| Neutral 200 | Cloud Veil | #E4E7EB | Borders, dividers |
| Neutral 50 | Ivory Glow | #FDFCF9 | Background |
| Success | Verdant Pulse | #16B676 | Positive statuses |
| Warning | Saffron Ember | #F29D38 | Pending actions |
| Error | Crimson Gate | #D94343 | Errors, destructive actions |
| Info | Azure Beacon | #3D8BFF | Informational banners |

- All colors meet WCAG AA contrast; variants (`050-900`) generated via token pipeline for light/dark themes.

## 3. Typography
- **Primary Typeface**: Inter (mobile/web safe) with optical sizing.
- **Scale** (base 16px, modular ratio 1.25):
  - Display: 40/48, Title: 28/36, Subtitle: 22/30, Body: 16/24, Caption: 13/18.
- Support dynamic type and platform text scaling; clamp line lengths to 60-75 characters for readability.

## 4. Spacing & Layout
- **Spacing Tokens**: `xs=4`, `sm=8`, `md=12`, `lg=16`, `xl=24`, `2xl=32`, `3xl=48` (dp/px).
- **Grid**: 4pt base grid; cards use 12dp padding.
- **Breakpoints**:
  - Compact (<=360dp): single-column feeds, bottom sheets for filters.
  - Standard (361-600dp): two-column property grid, persistent filter bar.
  - Expanded (>600dp): split-view layout (list + detail) for tablets.
- Use `LayoutBuilder` and `MediaQuery` to adapt components; prefer `Flex` + `Expanded` for fluidity.

## 5. Components Library
- Buttons: primary (filled), secondary (tonal), tertiary (text), destructive variant with confirmation CTA.
- Inputs: text fields with helper/error text, dropdowns, multi-select chips, range sliders for price filters.
- Cards: property cards (image + badges), lodging cards (rating + amenities), professional directory tiles.
- Navigation: bottom bar (3-5 tabs), FAB for post property, contextual top tabs for property/lodging toggle.
- Feedback: toast/snackbar, banner alerts, loading shimmers, skeleton states.
- Overlays: modal sheets for booking, stepper wizards for registration, map search drawer.
- All components built in a dedicated `broker_design_system` Flutter package with storybook catalog and golden tests.

## 6. Iconography & Imagery
- Use Remix Icons pack for consistency; convert to Flutter vector assets.
- Property type icons (land, house, condo), amenity icons (wifi, parking, pool) delivered as monochrome with theme tinting.
- Imagery: prefer high-resolution, compress on upload, generate aspect-ratio-safe thumbnails to avoid layout shift.

## 7. Motion & Micro-Interactions
- Animation curve: standard Material `easeInOutCubic` with 200-250ms duration; micro-interactions max 120ms.
- Implement hero transitions between list/detail, progress indicators for uploads, and subtle parallax on property cards.
- Respect OS reduced-motion settings via `MediaQuery.of(context).disableAnimations` guards.

## 8. Accessibility & Inclusive Design
- Minimum contrast ratio 4.5:1 for text, 3:1 for large UI elements.
- Provide semantic labels for every actionable element; announce booking confirmation via `SemanticsService.announce`.
- Support bi-directional layouts (future Arabic localization) and RTL testing.
- Offer adjustable text size, high-contrast theme toggle, and descriptive error messaging.

## 9. Responsive Behavior Checklist
- Orientation changes retain state; map searches persist filters.
- Keyboard avoidance for forms using `SafeArea` + scrollable layouts.
- Offline placeholders with retry affordances when connectivity drops.
- Animations degrade gracefully on low-end devices by reducing particle counts and blur effects.

## 10. Implementation Workflow
1. Define UI in Figma using above tokens; export JSON tokens via Style Dictionary.
2. Sync tokens to Flutter using code generation (`build_runner`) feeding custom `ThemeExtension`s.
3. Enforce component usage through lint rules and design review gates.
4. Monitor UI performance via Flutter DevTools metrics (rasterization time, frame build time) and Crashlytics for ANR tracking.
5. Capture visual regression snapshots for critical screens (auth, property detail, booking) as part of CI.

Adhering to this system guarantees the “best UI” directive, ensuring responsiveness, accessibility, and performance stay front-and-center.
