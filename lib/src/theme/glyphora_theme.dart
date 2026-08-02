import 'package:flutter/material.dart';

abstract final class GlyphoraTheme {
  static const _defaultSeedColor =
      Color(0xFF6750A4);

  static const _inputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static const _cardTheme = CardThemeData(
    margin: EdgeInsets.zero,
  );

  static const _dialogTheme = DialogThemeData(
    insetPadding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 24,
    ),
  );

  static ThemeData light({
    Color seedColor = _defaultSeedColor,
  }) {
    return _buildTheme(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark({
    Color seedColor = _defaultSeedColor,
  }) {
    return _buildTheme(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _buildTheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      inputDecorationTheme:
          _inputDecorationTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
    );
  }
}