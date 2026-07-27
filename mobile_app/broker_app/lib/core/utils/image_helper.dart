import 'package:broker_app/core/config/app_config.dart';

class ImageHelper {
  static String fixUrl(String url) {
    try {
      final configUrl = AppConfig.instance.apiBaseUrl;
      final uri = Uri.parse(configUrl);

      if (url.startsWith('/')) {
        return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}$url';
      }

      final incomingUri = Uri.parse(url);
      
      final isLocal = incomingUri.host == 'localhost' || 
                      incomingUri.host == '127.0.0.1' || 
                      incomingUri.host == '10.0.2.2' || 
                      incomingUri.host.startsWith('192.168.') ||
                      incomingUri.host.startsWith('10.');

      if (isLocal) {
        return incomingUri.replace(
          scheme: uri.scheme,
          host: uri.host,
          port: uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80),
        ).toString();
      }
    } catch (_) {}
    return url;
  }
}
