import 'package:flutter/material.dart';

/// Global configuration and initialization for the KR UI library.
/// Provides a global navigator key to support context-independent component calls.
class KruiInitializer {
  /// Global navigator key that should be assigned to your MaterialApp's navigatorKey property.
  ///
  /// ```dart
  /// MaterialApp(
  ///   navigatorKey: KruiInitializer.navigatorKey,
  ///   ...
  /// )
  /// ```
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Private constructor to prevent instantiation.
  KruiInitializer._();
}
