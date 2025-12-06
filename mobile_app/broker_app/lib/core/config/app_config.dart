import 'dart:convert';

import 'package:flutter/services.dart';

enum AppEnvironment { development, production }

class AppConfig {
  AppConfig({required this.apiBaseUrl});

  final String apiBaseUrl;

  static AppConfig? _instance;

  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('AppConfig has not been initialized');
    }
    return config;
  }

  static Future<void> load({AppEnvironment? environment}) async {
    const overrideBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );
    if (overrideBaseUrl.isNotEmpty) {
      _instance = AppConfig(apiBaseUrl: overrideBaseUrl);
      return;
    }

    final localOverride = await _loadLocalOverride();
    if (localOverride != null) {
      _instance = AppConfig(apiBaseUrl: localOverride);
      return;
    }

    final resolvedEnvironment = environment ?? _resolveEnvironment();
    final assetPath = 'assets/config/${resolvedEnvironment.name}.json';
    final raw = await rootBundle.loadString(assetPath);
    final map = json.decode(raw) as Map<String, dynamic>;
    final baseUrl = map['apiBaseUrl'] as String?;

    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('Missing "apiBaseUrl" in $assetPath');
    }

    _instance = AppConfig(apiBaseUrl: baseUrl);
  }

  static Future<String?> _loadLocalOverride() async {
    const assetPath = 'assets/config/local_override.json';
    try {
      final raw = await rootBundle.loadString(assetPath);
      final map = json.decode(raw) as Map<String, dynamic>;
      final baseUrl = (map['apiBaseUrl'] as String?)?.trim();
      if (baseUrl == null || baseUrl.isEmpty) {
        return null;
      }

      return baseUrl;
    } catch (_) {
      return null;
    }
  }

  static AppEnvironment _resolveEnvironment() {
    const envValue = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );

    switch (envValue.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'development':
      case 'dev':
      default:
        return AppEnvironment.development;
    }
  }
}
