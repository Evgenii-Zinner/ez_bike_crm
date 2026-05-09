import '../../utils/imports.dart';

/// Possible statuses for the maintenance list fetch operation.
enum MaintenanceListStatus {
  initial,
  loading,
  success,
  failure,
  refreshing,
}

/// State for the [MaintenanceListScreen].
///
/// Holds the list of maintenance records and the current loading status.
class MaintenanceListState extends Equatable {
  /// The current status of the list fetch.
  final MaintenanceListStatus status;

  /// The list of maintenance records to display.
  final List<Maintenance> maintenances;

  /// Error message if the fetch operation failed.
  final String? errorMessage;

  const MaintenanceListState({
    this.status = MaintenanceListStatus.initial,
    this.maintenances = const [],
    this.errorMessage,
  });

  /// Creates a copy of the state with specific fields updated.
  MaintenanceListState copyWith({
    MaintenanceListStatus? status,
    List<Maintenance>? maintenances,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MaintenanceListState(
      status: status ?? this.status,
      maintenances: maintenances ?? this.maintenances,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, maintenances, errorMessage];
}

/// ViewModel for the maintenance history list.
///
/// Handles fetching all maintenance logs, sorting them by date (newest first),
/// and coordinating with the [MaintenanceService].
class MaintenanceListViewModel extends StateNotifier<MaintenanceListState> {
  final MaintenanceService _maintenanceService;
  final Ref _ref;

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  MaintenanceListViewModel(this._maintenanceService, this._ref)
      : super(const MaintenanceListState()) {
    fetchMaintenances();
  }

  /// Fetches the full maintenance history and sorts it by date descending.
  Future<void> fetchMaintenances() async {
    if (state.status == MaintenanceListStatus.loading ||
        state.status == MaintenanceListStatus.refreshing) {
      return;
    }

    final isRefreshing = state.status == MaintenanceListStatus.success ||
        state.status == MaintenanceListStatus.failure;
    state = state.copyWith(
      status: isRefreshing
          ? MaintenanceListStatus.refreshing
          : MaintenanceListStatus.loading,
      clearErrorMessage: true,
    );

    try {
      final maintenancesMap = await _maintenanceService.getMaintenances();
      final maintenancesList = maintenancesMap.values.toList();

      // Sort by date: newest maintenance entries first.
      maintenancesList.sort((a, b) => b.date.compareTo(a.date));

      state = state.copyWith(
          status: MaintenanceListStatus.success,
          maintenances: maintenancesList);
    } catch (e) {
      state = state.copyWith(
          status: MaintenanceListStatus.failure,
          errorMessage: "${_appStrings.msgLoadFailed}: ${e.toString()}");
    }
  }

  /// Triggers a manual refresh of the maintenance logs.
  Future<void> refreshMaintenances() async {
    if (state.status != MaintenanceListStatus.refreshing &&
        state.status != MaintenanceListStatus.loading) {
      await fetchMaintenances();
    }
  }
}
