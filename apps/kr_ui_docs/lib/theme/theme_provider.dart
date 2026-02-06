import 'package:flutter/material.dart';
import 'theme_config.dart';

/// Theme provider for managing app theme state
class ThemeProvider extends ChangeNotifier {
  AppBrightnessMode _brightness = AppBrightnessMode.light;
  AppColorTheme _colorTheme = AppColorTheme.blue;

  AppBrightnessMode get brightness => _brightness;
  AppColorTheme get colorTheme => _colorTheme;

  bool get isDarkMode => _brightness == AppBrightnessMode.dark;
  bool get isLightMode => _brightness == AppBrightnessMode.light;

  /// Get current color theme data
  ColorThemeData get currentColorData =>
      ColorThemeData.get(_colorTheme, _brightness);

  /// Toggle between light and dark mode
  void toggleBrightness() {
    _brightness = isDarkMode ? AppBrightnessMode.light : AppBrightnessMode.dark;
    notifyListeners();
  }

  /// Set specific brightness mode
  void setBrightness(AppBrightnessMode mode) {
    if (_brightness != mode) {
      _brightness = mode;
      notifyListeners();
    }
  }

  /// Set color theme
  void setColorTheme(AppColorTheme theme) {
    if (_colorTheme != theme) {
      _colorTheme = theme;
      notifyListeners();
    }
  }

  /// Set both brightness and color theme at once
  void setTheme({
    AppBrightnessMode? brightness,
    AppColorTheme? colorTheme,
  }) {
    bool changed = false;

    if (brightness != null && _brightness != brightness) {
      _brightness = brightness;
      changed = true;
    }

    if (colorTheme != null && _colorTheme != colorTheme) {
      _colorTheme = colorTheme;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }
}
