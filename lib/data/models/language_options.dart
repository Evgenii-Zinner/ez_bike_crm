import 'package:flutter/material.dart';

/// Represents a language option available in the application.
class LanguageOption {
  /// The [Locale] associated with the language.
  final Locale locale;

  /// The display name of the language (e.g., 'English').
  final String name;

  /// The filename of the flag image asset.
  final String flag;

  LanguageOption(this.locale, this.name, this.flag);
}

/// The list of languages supported by the application.
final List<LanguageOption> supportedLanguages = [
  LanguageOption(const Locale('en'), 'English', 'united-kingdom.png'),
  LanguageOption(const Locale('vi'), 'Tiếng Việt', 'vietnam.png'),
];
