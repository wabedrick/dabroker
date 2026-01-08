# broker_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Maps (flutter_map + OpenStreetMap)

If you see a console message like:

`flutter_map wants to help keep map data available for everyone...`

it means you're using OpenStreetMap's public tile server (`https://tile.openstreetmap.org/...`).
That server has a usage policy (User-Agent, attribution, caching, and no bulk/offline prefetch).

Once you've read and understood the OSM tile usage policy, you can silence the reminder in debug runs by passing:

```bash
flutter run --dart-define=flutter.flutter_map.unblockOSM="Our tile servers are not: they are funded by donations and sponsorship, and capacity is limited."
```

In VS Code, you can use the provided launch config: `.vscode/launch.json`.
