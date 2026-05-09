import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'utils/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the sanitized options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wrap the entire app in a ProviderScope for Riverpod state management.
  runApp(const ProviderScope(child: BikeCRM()));
}

class BikeCRM extends ConsumerWidget {
  const BikeCRM({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final appStrings = ref.watch(localizationProvider);
    final currentLocale = ref.watch(localeProvider);

    final materialAppTitle = appStrings!.appName;

    return MaterialApp(
      // Configure localization delegates and supported locales.
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      title: materialAppTitle,

      // Theme configuration using a custom AppTheme class.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),

      // Authentication-based routing.
      home: authService.currentUser != null
          ? const MainScreen()
          : const LoginScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final AuthService authService = ref.read(authServiceProvider);

  static const String keyScreenGarage = 'screenTitleGarage';
  static const String keyScreenReports = 'screenTitleReports';
  static const String keyScreenRentals = 'screenTitleRentals';
  static const String keyScreenMaintenances = 'screenTitleMaintenances';
  static const String keyScreenCustomers = 'screenTitleCustomers';
  static const String keyScreenBikes = 'screenTitleBikes';

  final Map<String, Widget> _screenRouteWidgets = {
    keyScreenGarage: const GarageScreen(),
    keyScreenReports: const ReportsScreen(),
    keyScreenRentals: const RentalListScreen(),
    keyScreenMaintenances: const MaintenanceListScreen(),
    keyScreenCustomers: const CustomerListScreen(),
    keyScreenBikes: const BikeListScreen(),
  };

  final Map<String, String Function(AppLocalizations)> _localizedScreenTitles =
      {
    keyScreenGarage: (appStrings) => appStrings.screenGarage,
    keyScreenReports: (appStrings) => appStrings.screenReports,
    keyScreenRentals: (appStrings) => appStrings.screenRentals,
    keyScreenMaintenances: (appStrings) => appStrings.screenMaintenances,
    keyScreenCustomers: (appStrings) => appStrings.screenCustomers,
    keyScreenBikes: (appStrings) => appStrings.screenBikes,
  };

  late String _selectedScreenKey;

  @override
  void initState() {
    super.initState();
    _selectedScreenKey = keyScreenGarage;
  }

  String _getLocalizedTitle(AppLocalizations appStrings, String screenKey) {
    return _localizedScreenTitles[screenKey]?.call(appStrings) ??
        'Unknown Screen';
  }

  void _onSelectItem(String screenKey) {
    setState(() {
      _selectedScreenKey = screenKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Widget currentScreenWidget = _screenRouteWidgets[_selectedScreenKey]!;
    final String currentLocalizedScreenTitle =
        _getLocalizedTitle(appStrings, _selectedScreenKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentLocalizedScreenTitle),
        actions: [
          LanguageSwitcher(
            backgroundColor: colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EzCircleAvatar(
              foregroundColor: colorScheme.onPrimary,
              name: authService.currentUser?.displayName ?? '',
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                ),
                child: Text(
                  appStrings.appName,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ..._screenRouteWidgets.keys.map((screenKey) {
                    final localizedItemTitle =
                        _getLocalizedTitle(appStrings, screenKey);
                    return ListTile(
                      title: Text(localizedItemTitle),
                      selected: _selectedScreenKey == screenKey,
                      onTap: () {
                        _onSelectItem(screenKey);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      leading: Icon(
                        themeMode == ThemeMode.light
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        themeMode == ThemeMode.light
                            ? appStrings.themeDark
                            : appStrings.themeLight,
                      ),
                      onTap: () {
                        ref.read(themeModeProvider.notifier).state =
                            themeMode == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout,
                          color: colorScheme.onSurfaceVariant),
                      title: Text(appStrings.actionLogout),
                      onTap: () {
                        authService.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: currentScreenWidget,
    );
  }
}
