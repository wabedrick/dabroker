import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/core/auth/auth_repository.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/storage/storage_service.dart';
import 'package:broker_app/data/models/user.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthRepository(dioClient, storage);
});

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthStateNotifier(authRepository, storage);
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storage;

  AuthStateNotifier(this._authRepository, this._storage) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final userData = _storage.getUser();
    if (userData != null) {
      try {
        final user = User.fromJson(userData);
        state = state.copyWith(user: user, isAuthenticated: true);
      } catch (e) {
        // Invalid user data, clear it
        await _storage.clearUser();
      }
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String countryCode,
    required String password,
    required String passwordConfirmation,
    String? preferredRole,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        phone: phone,
        countryCode: countryCode,
        password: password,
        passwordConfirmation: passwordConfirmation,
        preferredRole: preferredRole,
      );

      state = state.copyWith(user: response.data, isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.login(
        identifier: identifier,
        password: password,
      );

      state = state.copyWith(
        user: response.data,
        isAuthenticated: true,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.verifyOtp(
        identifier: identifier,
        otp: otp,
        purpose: purpose,
      );

      // Refresh user data
      final userData = _storage.getUser();
      if (userData != null) {
        final user = User.fromJson(userData);
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      }

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.logout();
      state = AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshProfile() async {
    try {
      final user = await _authRepository.getProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      // Silently fail, user data might be outdated
    }
  }

  Future<bool> resendOtp({
    required String identifier,
    required String purpose,
  }) async {
    state = state.copyWith(error: null);
    try {
      await _authRepository.resendOtp(identifier: identifier, purpose: purpose);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}
