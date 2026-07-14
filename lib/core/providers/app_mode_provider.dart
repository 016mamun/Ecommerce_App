import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the two distinct store modes of the app.
enum AppMode { lifestyle, pharmacy }

/// Notifier that owns and controls the global [AppMode] state.
/// Persisting this at the top-level ProviderScope means every screen
/// instantly reacts to a mode switch without any navigation required.
class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(AppMode.lifestyle);

  void switchTo(AppMode mode) {
    if (state != mode) state = mode;
  }

  void toggleMode() {
    state = state == AppMode.lifestyle ? AppMode.pharmacy : AppMode.lifestyle;
  }
}

/// The single source of truth for the active app mode.
final appModeProvider = StateNotifierProvider<AppModeNotifier, AppMode>((ref) {
  return AppModeNotifier();
});

/// Convenience derived provider — true when Pharmacy mode is active.
final isPharmacyModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.pharmacy;
});
