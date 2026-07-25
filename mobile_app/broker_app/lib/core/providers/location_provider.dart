import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LocationState {
  final bool isLoading;
  final Position? position;
  final String? error;
  final bool isServiceDisabled;
  final bool isPermissionDenied;
  final bool isPermissionPermanentlyDenied;

  const LocationState({
    this.isLoading = false,
    this.position,
    this.error,
    this.isServiceDisabled = false,
    this.isPermissionDenied = false,
    this.isPermissionPermanentlyDenied = false,
  });

  LocationState copyWith({
    bool? isLoading,
    Position? position,
    String? error,
    bool? isServiceDisabled,
    bool? isPermissionDenied,
    bool? isPermissionPermanentlyDenied,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      error: error, // Nullable override
      isServiceDisabled: isServiceDisabled ?? this.isServiceDisabled,
      isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
      isPermissionPermanentlyDenied:
          isPermissionPermanentlyDenied ?? this.isPermissionPermanentlyDenied,
    );
  }
}

class LocationProvider extends StateNotifier<LocationState> {
  LocationProvider() : super(const LocationState());

  Future<Position?> getCurrentLocation() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      isServiceDisabled: false,
      isPermissionDenied: false,
      isPermissionPermanentlyDenied: false,
    );

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          isServiceDisabled: true,
          error: 'Location services are disabled.',
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            isPermissionDenied: true,
            error: 'Location permissions are denied.',
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          isPermissionPermanentlyDenied: true,
          error: 'Location permissions are permanently denied.',
        );
        return null;
      }

      Position? position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        final age = DateTime.now().difference(position.timestamp);
        if (age.inMinutes > 5) {
          position = null; 
        }
      }

      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );

      state = state.copyWith(isLoading: false, position: position, error: null);
      return position;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  void openSettings() {
    if (state.isServiceDisabled) {
      Geolocator.openLocationSettings();
    } else if (state.isPermissionPermanentlyDenied) {
      Geolocator.openAppSettings();
    }
  }

  void clearLocation() {
    state = const LocationState();
  }
}

final locationProvider =
    StateNotifierProvider<LocationProvider, LocationState>((ref) {
  return LocationProvider();
});
