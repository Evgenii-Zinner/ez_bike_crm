import '../../utils/imports.dart';

/// Supported time periods for report aggregation.
enum ReportPeriodType { month, year }

/// UI state for the Reports screen.
///
/// Holds the selected period, loading status, aggregated financial data,
/// and fleet status counts.
class ReportsScreenState extends Equatable {
  /// Whether reports are aggregated by month or year.
  final ReportPeriodType selectedPeriodType;

  /// The specific date (month/year) for which the report is being viewed.
  final DateTime selectedDate;

  /// Whether data is currently being fetched or processed.
  final bool isLoading;

  /// Error message if data aggregation failed.
  final String? errorMessage;

  /// Aggregated rental earnings for the period.
  final double totalEarnings;

  /// Aggregated maintenance costs for the period.
  final double totalMaintenanceCosts;

  /// Net profit (earnings - costs).
  final double balance;

  /// Number of bikes currently rented out.
  final int bikesInRentCount;

  /// Number of bikes currently available in the garage.
  final int bikesAvailableCount;

  /// Number of bikes currently in maintenance.
  final int totalBikesInMaintenance;

  /// Total monetary value of deposits currently held.
  final double totalDepositsHeld;

  /// Total number of physical documents (like IDs) held as deposit.
  final int totalDepositDocumentsHeld;

  const ReportsScreenState({
    this.selectedPeriodType = ReportPeriodType.month,
    required this.selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.totalEarnings = 0.0,
    this.totalMaintenanceCosts = 0.0,
    this.balance = 0.0,
    this.bikesInRentCount = 0,
    this.bikesAvailableCount = 0,
    this.totalBikesInMaintenance = 0,
    this.totalDepositsHeld = 0,
    this.totalDepositDocumentsHeld = 0,
  });

  /// Factory for the initial state, starting at the current month.
  factory ReportsScreenState.initial() {
    return ReportsScreenState(
      selectedDate: DateTime.now(),
    );
  }

  /// Creates a copy of the state with updated fields.
  ReportsScreenState copyWith({
    ReportPeriodType? selectedPeriodType,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    double? totalEarnings,
    double? totalMaintenanceCosts,
    double? balance,
    int? bikesInRentCount,
    int? bikesAvailableCount,
    int? totalBikesInMaintenance,
    double? totalDepositsHeld,
    int? totalDepositDocumentsHeld,
  }) {
    return ReportsScreenState(
      selectedPeriodType: selectedPeriodType ?? this.selectedPeriodType,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalMaintenanceCosts:
          totalMaintenanceCosts ?? this.totalMaintenanceCosts,
      balance: balance ?? this.balance,
      bikesInRentCount: bikesInRentCount ?? this.bikesInRentCount,
      bikesAvailableCount: bikesAvailableCount ?? this.bikesAvailableCount,
      totalBikesInMaintenance:
          totalBikesInMaintenance ?? this.totalBikesInMaintenance,
      totalDepositsHeld: totalDepositsHeld ?? this.totalDepositsHeld,
      totalDepositDocumentsHeld:
          totalDepositDocumentsHeld ?? this.totalDepositDocumentsHeld,
    );
  }

  @override
  List<Object?> get props => [
        selectedPeriodType,
        selectedDate,
        isLoading,
        errorMessage,
        totalEarnings,
        totalMaintenanceCosts,
        balance,
        bikesInRentCount,
        bikesAvailableCount,
        totalBikesInMaintenance,
        totalDepositsHeld,
        totalDepositDocumentsHeld,
      ];
}

/// ViewModel for the Reports screen, handling data aggregation and Excel generation.
///
/// It coordinates between multiple services ([RentalService], [MaintenanceService], [BikeService])
/// to provide a comprehensive financial and operational overview.
class ReportsViewModel extends StateNotifier<ReportsScreenState> {
  final Ref _ref;

  RentalService get _rentalService => _ref.read(rentalServiceProvider);
  MaintenanceService get _maintenanceService =>
      _ref.read(maintenanceServiceProvider);
  BikeService get _bikeService => _ref.read(bikeServiceProvider);

  CustomerService get _customerService => _ref.read(customerServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  ReportsViewModel(this._ref) : super(ReportsScreenState.initial()) {
    loadReportData();
  }

  /// Switches between monthly and yearly aggregation.
  void setPeriodType(ReportPeriodType periodType) {
    if (state.selectedPeriodType == periodType) return;
    state = state.copyWith(selectedPeriodType: periodType, isLoading: true);
    loadReportData();
  }

  /// Sets the specific date for the report and triggers a data refresh.
  void setSelectedDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, 1);
    if (state.selectedPeriodType == ReportPeriodType.year) {
      normalizedDate = DateTime(date.year, 1, 1);
    }

    if (state.selectedDate.year == normalizedDate.year &&
        state.selectedDate.month == normalizedDate.month &&
        state.selectedPeriodType == state.selectedPeriodType) {
      return;
    }
    state = state.copyWith(selectedDate: normalizedDate, isLoading: true);
    loadReportData();
  }

  /// Moves the current view to the previous month or year.
  void goToPreviousPeriod() {
    DateTime newDate;
    if (state.selectedPeriodType == ReportPeriodType.month) {
      newDate =
          DateTime(state.selectedDate.year, state.selectedDate.month - 1, 1);
    } else {
      newDate = DateTime(state.selectedDate.year - 1, 1, 1);
    }
    setSelectedDate(newDate);
  }

  /// Moves the current view to the next month or year.
  void goToNextPeriod() {
    DateTime newDate;
    if (state.selectedPeriodType == ReportPeriodType.month) {
      newDate =
          DateTime(state.selectedDate.year, state.selectedDate.month + 1, 1);
    } else {
      newDate = DateTime(state.selectedDate.year + 1, 1, 1);
    }
    setSelectedDate(newDate);
  }

  /// Aggregates financial and operational data for the selected period.
  Future<void> loadReportData() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      Map<String, Rental> rentalsMap;
      Map<String, Maintenance> maintenancesMap;

      // Fetch relevant data based on the period type.
      if (state.selectedPeriodType == ReportPeriodType.month) {
        rentalsMap =
            await _rentalService.getRentalsForMonth(state.selectedDate);
        maintenancesMap = await _maintenanceService
            .getMaintenancesForMonth(state.selectedDate);
      } else {
        rentalsMap = await _rentalService.getRentalsForYear(state.selectedDate);
        maintenancesMap = await _maintenanceService
            .getMaintenancesForYear(state.selectedDate);
      }

      final List<Rental> periodRentals = rentalsMap.values.toList();
      final List<Maintenance> periodMaintenances =
          maintenancesMap.values.toList();

      // Sum earnings and costs locally.
      double currentTotalEarnings = 0;
      for (var rental in periodRentals) {
        currentTotalEarnings += rental.finalPrice;
      }

      double currentTotalMaintenanceCosts = 0;
      for (var maintenance in periodMaintenances) {
        currentTotalMaintenanceCosts += maintenance.price;
      }

      final currentBalance =
          currentTotalEarnings - currentTotalMaintenanceCosts;

      // Fetch fleet status snapshots.
      final Map<String, Bike> rentedBikesMap =
          await _bikeService.getBikesByStatus(BikeStatusConstants.rented);
      final int currentBikesActuallyRentedState = rentedBikesMap.length;

      final Map<String, Bike> maintenanceBikesMap =
          await _bikeService.getBikesByStatus(BikeStatusConstants.maintenance);
      final int currentBikesActuallyInMaintenanceState =
          maintenanceBikesMap.length;

      final Map<String, Bike> allBikesMap = await _bikeService.getBikes();
      final int totalBikeCount = allBikesMap.length;

      final currentBikesAvailableCount = (totalBikeCount -
              currentBikesActuallyRentedState -
              currentBikesActuallyInMaintenanceState)
          .clamp(0, totalBikeCount);

      // Fetch total deposits held across all active rentals.
      final depositDetails = await _rentalService.getDepositsAmount();

      final double currentTotalDepositsHeld = depositDetails.deposits;
      final int currentTotalDepositDocumentsHeld = depositDetails.documents;

      state = state.copyWith(
        totalEarnings: currentTotalEarnings,
        totalMaintenanceCosts: currentTotalMaintenanceCosts,
        balance: currentBalance,
        bikesInRentCount: currentBikesActuallyRentedState,
        bikesAvailableCount: currentBikesAvailableCount,
        totalBikesInMaintenance: currentBikesActuallyInMaintenanceState,
        totalDepositsHeld: currentTotalDepositsHeld,
        totalDepositDocumentsHeld: currentTotalDepositDocumentsHeld,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: "${_appStrings.msgLoadFailed}: ${e.toString()}");
    }
  }

  /// Generates a byte list containing an Excel file with detailed report data.
  ///
  /// The report includes lists of rentals, maintenances, customers, and bikes
  /// for the selected period.
  Future<List<int>?> prepareExcelReport() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      Map<String, Rental> rentalsMapForReport;
      Map<String, Maintenance> maintenancesMapForReport;
      DateTime reportPeriodStart;
      DateTime reportPeriodEnd;

      if (state.selectedPeriodType == ReportPeriodType.month) {
        reportPeriodStart =
            DateTime(state.selectedDate.year, state.selectedDate.month, 1);
        reportPeriodEnd =
            DateTime(state.selectedDate.year, state.selectedDate.month + 1, 0);

        rentalsMapForReport =
            await _rentalService.getRentalsForMonth(state.selectedDate);
        maintenancesMapForReport = await _maintenanceService
            .getMaintenancesForMonth(state.selectedDate);
      } else {
        reportPeriodStart = DateTime(state.selectedDate.year, 1, 1);
        reportPeriodEnd = DateTime(state.selectedDate.year, 12, 31);

        rentalsMapForReport =
            await _rentalService.getRentalsForYear(state.selectedDate);
        maintenancesMapForReport = await _maintenanceService
            .getMaintenancesForYear(state.selectedDate);
      }

      final List<Rental> periodRentals = rentalsMapForReport.values.toList();
      final List<Maintenance> periodMaintenances =
          maintenancesMapForReport.values.toList();

      final allBikesMap = await _bikeService.getBikes();
      final allCustomersMap = await _customerService.getCustomers();

      // Trigger the specialized generation service.
      final List<int>? excelBytes = await generateFullReportExcel(
        appStrings: _appStrings,
        rentalsForPeriod: periodRentals,
        maintenancesForPeriod: periodMaintenances,
        allBikes: allBikesMap.values.toList(),
        allCustomers: allCustomersMap.values.toList(),
        periodStart: reportPeriodStart,
        periodEnd: reportPeriodEnd,
      );

      state = state.copyWith(isLoading: false);
      return excelBytes;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage:
              "${_appStrings.labelFailedToCreateReport}: ${e.toString()}");
      return null;
    }
  }
}
