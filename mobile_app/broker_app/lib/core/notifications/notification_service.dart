import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../providers/app_providers.dart';
import '../../features/notifications/providers/notification_counters_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrapper.ensureInitialized();
  if (!FirebaseBootstrapper.available) {
    return;
  }

  await AppConfig.load();
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  try {
    await container.read(notificationCountersProvider.notifier).refresh();
  } finally {
    container.dispose();
  }
}

class FirebaseBootstrapper {
  static bool _available = true;

  static bool get available => _available;

  static Future<void> ensureInitialized() async {
    if (!_available) return;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (error, stackTrace) {
      _available = false;
      debugPrint('Firebase initialization failed: $error');
      debugPrint(stackTrace.toString());
    }
  }
}

class NotificationService {
  NotificationService(this._ref);

  final Ref _ref;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await FirebaseBootstrapper.ensureInitialized();
    if (!FirebaseBootstrapper.available) {
      debugPrint('Firebase unavailable; skipping notification setup.');
      return;
    }

    await _requestPermissions();
    await _setupMessageStreams();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Push notification permission denied');
    }
  }

  Future<void> _setupMessageStreams() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final shouldRefresh = data['refreshCounters'] != 'false';
    if (!shouldRefresh) return;
    _ref.read(notificationCountersProvider.notifier).refresh();
  }
}
