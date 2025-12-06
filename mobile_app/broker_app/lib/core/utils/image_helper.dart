import 'package:broker_app/core/config/app_config.dart';

class ImageHelper {
  static String fixUrl(String url) {
    try {
      final configUrl = AppConfig.instance.apiBaseUrl;
      final uri = Uri.parse(configUrl);

      if (url.startsWith('/')) {
        return '${uri.scheme}://${uri.host}:${uri.port}$url';
      }

      if (url.contains('localhost')) {
        return url.replaceFirst('localhost', uri.host);
      }

      if (url.contains('192.168.42.73')) {
        return url.replaceFirst('192.168.42.73', uri.host);
      }
    } catch (_) {}
    return url;
  }
}
