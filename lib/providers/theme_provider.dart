import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track the app's current theme (dark mode or light mode)
///
/// Returns true if the theme is dark mode, false for light mode
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

/// Notifier class to manage the theme state changes
class ThemeNotifier extends StateNotifier<bool> {
  // Initialize with light mode (false)
  ThemeNotifier() : super(false);

  /// Toggle between dark and light mode
  void toggleTheme() {
    state = !state;
  }

  /// Set to dark mode
  void setDarkMode() {
    state = true;
  }

  /// Set to light mode
  void setLightMode() {
    state = false;
  }
}
