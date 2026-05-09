import '../utils/imports.dart';

/// A circular button widget that displays the current language flag and cycles
/// through available languages when tapped.
class LanguageSwitcher extends ConsumerWidget {
  /// The diameter of the switcher button.
  final double size;

  /// Optional background color for the button.
  final Color? backgroundColor;

  const LanguageSwitcher({
    super.key,
    this.size = 40.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    // Find the current language option to determine which flag to display.
    final currentLangOption = supportedLanguages.firstWhere(
      (lang) => lang.locale == currentLocale,
      orElse: () => supportedLanguages.first,
    );

    final String imagePath = 'assets/flags/${currentLangOption.flag}';

    return Material(
      color: backgroundColor ?? Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          // Trigger the language cycle via the locale notifier.
          ref.read(localeProvider.notifier).cycleToNextLanguage();
        },
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Image.asset(
              imagePath,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: size * 0.6);
              },
            ),
          ),
        ),
      ),
    );
  }
}
