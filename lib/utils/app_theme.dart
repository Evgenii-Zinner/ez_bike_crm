import 'imports.dart';

/// Centralized theme configuration for the application.
///
/// Defines light and dark color schemes, input decoration themes,
/// and overall [ThemeData] using Material 3 design principles.
class AppTheme {
  /// Seed-based light color scheme.
  static ColorScheme lightScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple, brightness: Brightness.light);

  /// Seed-based dark color scheme.
  static ColorScheme darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple, brightness: Brightness.dark);

  /// Shared input field styling for the entire app.
  static InputDecorationTheme inputsTheme = InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)));

  /// The primary light theme configuration.
  static ThemeData lightTheme = ThemeData(
      colorScheme: lightScheme,
      useMaterial3: true,
      inputDecorationTheme: inputsTheme);

  /// The primary dark theme configuration.
  static ThemeData darkTheme = ThemeData(
      colorScheme: darkScheme,
      useMaterial3: true,
      inputDecorationTheme: inputsTheme);
}
