import '../../utils/imports.dart';

enum GarageStatus { initial, loading, success, failure, refreshing }

/// Represents the UI state for the Garage screen.
///
/// It holds the list of bikes, filtering criteria, and loading status.
class GarageState extends Equatable {
  /// The current status of the garage data loading process.
  final GarageStatus status;

  /// All bikes fetched from the service, before filtering.
  final Map<String, Bike> allFetchedBikes;

  /// Maps bike registration plates to their expected return dates if they are rented.
  final Map<String, DateTime> rentedBikesDates;

  /// The list of bikes currently displayed after applying filters.
  final List<Bike> filteredBikes;

  /// The search query for the registration plate number.
  final String plateNumberFilter;

  /// The currently selected model filter.
  final String? selectedModel;

  /// The currently selected status filter (e.g., Garage, Rented, Maintenance).
  final String? selectedStatus;

  /// List of unique bike models available for filtering.
  final List<String> availableModels;

  /// List of unique bike statuses available for filtering.
  final List<String> availableStatuses;

  /// Error message to display if the fetch operation fails.
  final String? errorMessage;

  const GarageState({
    this.status = GarageStatus.initial,
    this.allFetchedBikes = const {},
    this.filteredBikes = const [],
    this.rentedBikesDates = const {},
    this.plateNumberFilter = "",
    this.selectedModel,
    this.selectedStatus,
    this.availableModels = const [],
    this.availableStatuses = const [],
    this.errorMessage,
  });

  /// Creates a copy of the state with updated fields.
  GarageState copyWith({
    GarageStatus? status,
    Map<String, Bike>? allFetchedBikes,
    Map<String, DateTime>? rentedBikesDates,
    List<Bike>? filteredBikes,
    String? plateNumberFilter,
    String? selectedModel,
    bool clearSelectedModel = false,
    String? selectedStatus,
    bool clearSelectedStatus = false,
    List<String>? availableModels,
    List<String>? availableStatuses,
    String? errorMessage,
  }) {
    return GarageState(
      status: status ?? this.status,
      allFetchedBikes: allFetchedBikes ?? this.allFetchedBikes,
      rentedBikesDates: rentedBikesDates ?? this.rentedBikesDates,
      filteredBikes: filteredBikes ?? this.filteredBikes,
      plateNumberFilter: plateNumberFilter ?? this.plateNumberFilter,
      selectedModel:
          clearSelectedModel ? null : selectedModel ?? this.selectedModel,
      selectedStatus:
          clearSelectedStatus ? null : selectedStatus ?? this.selectedStatus,
      availableModels: availableModels ?? this.availableModels,
      availableStatuses: availableStatuses ?? this.availableStatuses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allFetchedBikes,
        filteredBikes,
        plateNumberFilter,
        selectedModel,
        selectedStatus,
        availableModels,
        availableStatuses,
        errorMessage,
        rentedBikesDates,
      ];
}

/// ViewModel for the Garage screen using Riverpod's [StateNotifier].
///
/// Responsible for fetching bikes, managing filtering logic, and
/// coordinating with the [BikeService] and [RentalService].
class GarageViewModel extends StateNotifier<GarageState> {
  final BikeService _bikeService;
  final RentalService _rentalService;

  GarageViewModel(this._bikeService, this._rentalService)
      : super(const GarageState()) {
    fetchBikes(isInitialLoad: true);
  }

  /// Fetches all bikes and their associated rental details.
  ///
  /// Updates [GarageState] with loading status, fetched data, and
  /// available filter options.
  Future<void> fetchBikes({bool isInitialLoad = false}) async {
    state = state.copyWith(
      status: isInitialLoad ? GarageStatus.loading : GarageStatus.refreshing,
      errorMessage: null,
    );

    try {
      final bikesMap = await _bikeService.getBikes();
      final Map<String, DateTime> newRentedBikesDates = {};

      // Concurrently fetch rental details for all rented bikes to show return dates.
      List<Future<MapEntry<String, DateTime>?>> rentalDetailFutures = bikesMap
          .values
          .where((bike) =>
              bike.lastRentalId.isNotEmpty &&
              bike.bikeStatus == BikeStatusConstants.rented)
          .map((bike) async {
        final rental = await _rentalService.getRental(bike.lastRentalId);
        if (rental != null) {
          return MapEntry(bike.registrationPlate, rental.endDate);
        }
        return null;
      }).toList();

      final List<MapEntry<String, DateTime>?> results =
          await Future.wait(rentalDetailFutures);

      for (final entry in results) {
        if (entry != null) {
          newRentedBikesDates[entry.key] = entry.value;
        }
      }

      final newAllFetchedBikes = Map<String, Bike>.from(bikesMap);
      final newAvailableModels = newAllFetchedBikes.values
          .map((b) => b.model)
          .toSet()
          .toList()
        ..sort();
      final newAvailableStatuses = newAllFetchedBikes.values
          .map((b) => b.bikeStatus)
          .toSet()
          .toList()
        ..sort();

      String? currentSelectedModel = state.selectedModel;
      String? currentSelectedStatus = state.selectedStatus;

      // Reset filters if the previously selected options are no longer available.
      if (currentSelectedModel != null &&
          !newAvailableModels.contains(currentSelectedModel)) {
        currentSelectedModel = null;
      }
      if (currentSelectedStatus != null &&
          !newAvailableStatuses.contains(currentSelectedStatus)) {
        currentSelectedStatus = null;
      }

      state = state.copyWith(
        allFetchedBikes: newAllFetchedBikes,
        rentedBikesDates: newRentedBikesDates,
        availableModels: newAvailableModels,
        availableStatuses: newAvailableStatuses,
        selectedModel: currentSelectedModel,
        selectedStatus: currentSelectedStatus,
        status: GarageStatus.success,
      );

      _filterBikes();
    } catch (e) {
      state = state.copyWith(
        status: GarageStatus.failure,
        errorMessage: "Failed to load bikes: $e",
        allFetchedBikes: {},
        availableModels: [],
        availableStatuses: [],
        selectedModel: null,
        clearSelectedModel: true,
        selectedStatus: null,
        clearSelectedStatus: true,
      );
      _filterBikes();
    }
  }

  /// Internal method to apply active filters to the [allFetchedBikes] list.
  void _filterBikes() {
    if (state.allFetchedBikes.isEmpty) {
      state = state.copyWith(filteredBikes: []);
      return;
    }

    final currentFilteredBikes = state.allFetchedBikes.values.where((bike) {
      final plateNumberMatch = state.plateNumberFilter.isEmpty ||
          bike.registrationPlate
              .toLowerCase()
              .contains(state.plateNumberFilter.toLowerCase());

      final modelMatch =
          state.selectedModel == null || bike.model == state.selectedModel;

      final statusMatch = state.selectedStatus == null ||
          bike.bikeStatus == state.selectedStatus;

      return plateNumberMatch && modelMatch && statusMatch;
    }).toList();

    state = state.copyWith(
      filteredBikes: currentFilteredBikes,
    );
  }

  /// Updates the registration plate filter and triggers re-filtering.
  void onPlateNumberFilterChanged(String value) {
    state = state.copyWith(plateNumberFilter: value);
    _filterBikes();
  }

  /// Updates the model filter and triggers re-filtering.
  void onModelChanged(String? value) {
    state =
        state.copyWith(selectedModel: value, clearSelectedModel: value == null);
    _filterBikes();
  }

  /// Updates the status filter and triggers re-filtering.
  void onStatusChanged(String? value) {
    state = state.copyWith(
        selectedStatus: value, clearSelectedStatus: value == null);
    _filterBikes();
  }

  void clearPlateNumberFilter() {
    state = state.copyWith(plateNumberFilter: '');
    _filterBikes();
  }

  void clearModelFilter() {
    state = state.copyWith(selectedModel: null, clearSelectedModel: true);
    _filterBikes();
  }

  void clearStatusFilter() {
    state = state.copyWith(selectedStatus: null, clearSelectedStatus: true);
    _filterBikes();
  }
}
