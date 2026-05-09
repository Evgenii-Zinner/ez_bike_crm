import '../utils/imports.dart';

/// Notifier that manages the application's current [Locale] and persists
/// the user's selection in local storage.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(supportedLanguages.first.locale) {
    _loadLocale();
  }

  /// Loads the persisted locale from [SharedPreferences] or defaults
  /// to the first supported language.
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('selected_locale_code');
    if (localeCode != null && localeCode.isNotEmpty) {
      final loadedLocale = Locale(localeCode);
      if (supportedLanguages.any((lang) => lang.locale == loadedLocale)) {
        state = loadedLocale;
      } else {
        state = supportedLanguages.first.locale;
        await prefs.setString('selected_locale_code', state.languageCode);
      }
    } else {
      state = supportedLanguages.first.locale;
      await prefs.setString('selected_locale_code', state.languageCode);
    }
  }

  /// Updates the current locale and persists it.
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale ||
        !supportedLanguages.any((lang) => lang.locale == newLocale)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale_code', newLocale.languageCode);
    state = newLocale;
  }

  /// Cycles through all [supportedLanguages].
  Future<void> cycleToNextLanguage() async {
    final currentIndex =
        supportedLanguages.indexWhere((lang) => lang.locale == state);
    int nextIndex = 0;

    if (currentIndex != -1) {
      nextIndex = (currentIndex + 1) % supportedLanguages.length;
    }

    await setLocale(supportedLanguages[nextIndex].locale);
  }

  /// Returns the [LanguageOption] corresponding to the current state.
  LanguageOption get currentLanguageOption {
    return supportedLanguages.firstWhere((lang) => lang.locale == state,
        orElse: () => supportedLanguages.first);
  }
}

/// Provider for the [LocaleNotifier], exposing the current [Locale].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Notifier that provides the [AppLocalizations] instance for the current locale.
///
/// It listens to the [localeProvider] and automatically reloads the
/// localization strings whenever the language changes.
class LocalizationNotifier extends StateNotifier<AppLocalizations?> {
  final Ref _ref;
  Locale _currentLocale;

  LocalizationNotifier(this._ref, this._currentLocale) : super(null) {
    _loadLocalizations(_currentLocale);

    // Listen for locale changes and refresh localization data.
    _ref.listen<Locale>(localeProvider, (previousLocale, newLocale) {
      if (previousLocale != newLocale) {
        _currentLocale = newLocale;
        _loadLocalizations(newLocale);
      }
    });
  }

  /// Loads the actual [AppLocalizations] delegate for the given [locale].
  Future<void> _loadLocalizations(Locale locale) async {
    try {
      final localizations = await AppLocalizations.delegate.load(locale);
      if (mounted) {
        state = localizations;
      }
    } catch (e) {
      if (mounted) {
        state = null;
      }
    }
  }

  /// Returns the locale currently used for localization strings.
  Locale get currentLocale => _currentLocale;
}
