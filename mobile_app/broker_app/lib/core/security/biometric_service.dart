import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics.timeout(const Duration(seconds: 3));
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported().timeout(const Duration(seconds: 3));
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to securely unlock DaBroker',
      ).timeout(const Duration(seconds: 60)); // Give user 60 seconds to authenticate
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
