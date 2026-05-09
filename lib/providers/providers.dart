import '../utils/imports.dart';

// --- Infrastructure & Configuration Providers ---

/// Provides the current [AppLocalizations] based on the selected locale.
final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, AppLocalizations?>((ref) {
  final initialLocale = ref.watch(localeProvider);
  return LocalizationNotifier(ref, initialLocale);
});

/// Manages the application's theme mode (Light, Dark, or System).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Provides a single instance of [DatabaseService] for data persistence.
final databaseServiceProvider = ChangeNotifierProvider<DatabaseService>((ref) {
  return DatabaseService();
});

/// Provides the authentication service for user sign-in/sign-out.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// --- Low-Level Database Service Providers ---

/// Provides the database wrapper specifically for [Bike] entities.
final bikeDbServiceProvider = Provider<BikeDbService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return BikeDbService(databaseService);
});

/// Provides the database wrapper specifically for [Rental] entities.
final rentalDbServiceProvider = Provider<RentalDbService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return RentalDbService(databaseService);
});

/// Provides the database wrapper specifically for [Customer] entities.
final customerDbServiceProvider = Provider<CustomerDbService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return CustomerDbService(databaseService);
});

/// Provides the database wrapper specifically for [Maintenance] entities.
final maintenanceDbServiceProvider = Provider<MaintenanceDbService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return MaintenanceDbService(databaseService);
});

// --- Domain Logic Service Providers ---

/// Provides the domain-level service for bike fleet management.
final bikeServiceProvider = Provider<BikeService>((ref) {
  final bikeDb = ref.watch(bikeDbServiceProvider);
  return BikeService(bikeDb);
});

/// Provides the domain-level service for rental operations.
final rentalServiceProvider = Provider<RentalService>((ref) {
  final rentalDb = ref.watch(rentalDbServiceProvider);
  return RentalService(rentalDb);
});

/// Provides the domain-level service for customer management.
final customerServiceProvider = Provider<CustomerService>((ref) {
  final customerDb = ref.watch(customerDbServiceProvider);
  return CustomerService(customerDb);
});

/// Provides the domain-level service for bike maintenance tracking.
final maintenanceServiceProvider = Provider<MaintenanceService>((ref) {
  final maintenanceDb = ref.watch(maintenanceDbServiceProvider);
  return MaintenanceService(maintenanceDb);
});

// --- ViewModel Providers ---

/// Provides the ViewModel for the rental editing screen, parameterized by rental or bike.
final rentalEditViewModelProvider = StateNotifierProvider.autoDispose.family<
    RentalEditViewModel,
    RentalEditState,
    ({Rental? rental, Bike? bike})>((ref, params) {
  return RentalEditViewModel(ref, params.rental, params.bike);
});

/// Provides the ViewModel for the history list of rentals.
final rentalListViewModelProvider =
    StateNotifierProvider.autoDispose<RentalListViewModel, RentalListState>(
        (ref) {
  return RentalListViewModel(ref);
});

/// Provides the ViewModel for the bike return process, parameterized by the specific bike.
final returnEditViewModelProvider =
    StateNotifierProvider.family<ReturnEditViewModel, ReturnBikeState, Bike>(
        (ref, bike) {
  return ReturnEditViewModel(ref, bike);
});

/// Provides the ViewModel for the primary Garage/Dashboard screen.
final garageViewModelProvider =
    StateNotifierProvider<GarageViewModel, GarageState>((ref) {
  return GarageViewModel(
      ref.read(bikeServiceProvider), ref.read(rentalServiceProvider));
});

/// Provides the ViewModel for the maintenance history list.
final maintenanceListViewModelProvider = StateNotifierProvider.autoDispose<
    MaintenanceListViewModel, MaintenanceListState>((ref) {
  return MaintenanceListViewModel(ref.read(maintenanceServiceProvider), ref);
});

/// Provides the ViewModel for logging maintenance, parameterized by maintenance record or bike.
final maintenanceEditViewModelProvider = StateNotifierProvider.autoDispose
    .family<MaintenanceEditViewModel, MaintenanceEditState,
        ({Maintenance? maintenance, Bike? bike})>((ref, params) {
  return MaintenanceEditViewModel(ref, params.maintenance, params.bike);
});

/// Provides the ViewModel for adding or editing customers.
final customerEditViewModelProvider = StateNotifierProvider.autoDispose
    .family<CustomerEditViewModel, CustomerEditState, Customer?>(
        (ref, initialCustomer) {
  return CustomerEditViewModel(ref, initialCustomer);
});

/// Provides the ViewModel for the customer directory list.
final customerListViewModelProvider =
    StateNotifierProvider<CustomerListViewModel, CustomerListState>((ref) {
  return CustomerListViewModel(ref);
});

/// Provides the ViewModel for adding or editing bikes in the inventory.
final bikeEditViewModelProvider = StateNotifierProvider.autoDispose
    .family<BikeEditViewModel, BikeEditState, Bike?>((ref, initialBike) {
  return BikeEditViewModel(ref, initialBike);
});

/// Provides the ViewModel for the full list of bikes in the inventory.
final bikeListViewModelProvider =
    StateNotifierProvider<BikeListViewModel, BikeListState>((ref) {
  return BikeListViewModel(ref);
});

/// Provides the ViewModel for the financial and operational reporting screen.
final reportsViewModelProvider =
    StateNotifierProvider.autoDispose<ReportsViewModel, ReportsScreenState>(
        (ref) {
  return ReportsViewModel(ref);
});
