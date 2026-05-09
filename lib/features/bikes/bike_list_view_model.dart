import '../../utils/imports.dart';

/// Statuses for the bike list loading state.
enum BikeListStatus { initial, loading, success, failure }

/// State object for the bike list screen.
class BikeListState {
  /// Current fetch status.
  final BikeListStatus status;

  /// List of bikes to display.
  final List<Bike> bikes;

  /// Error message if the fetch failed.
  final String? errorMessage;

  const BikeListState({
    this.status = BikeListStatus.initial,
    this.bikes = const [],
    this.errorMessage,
  });

  /// Creates a copy of the state with updated fields.
  BikeListState copyWith({
    BikeListStatus? status,
    List<Bike>? bikes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BikeListState(
      status: status ?? this.status,
      bikes: bikes ?? this.bikes,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel managing the bike list, handling sorting and data retrieval.
class BikeListViewModel extends StateNotifier<BikeListState> {
  final Ref _ref;

  BikeListViewModel(this._ref) : super(const BikeListState()) {
    fetchBikes();
  }

  BikeService get _bikeService => _ref.read(bikeServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  /// Fetches the full list of bikes and sorts them by registration plate.
  Future<void> fetchBikes({bool isRefresh = false}) async {
    if (state.status == BikeListStatus.loading && !isRefresh) return;

    state =
        state.copyWith(status: BikeListStatus.loading, clearErrorMessage: true);
    try {
      final bikesMap = await _bikeService.getBikes();
      final bikesList = bikesMap.values.toList();

      // Sort alphabetically by plate number for consistent display.
      bikesList.sort((a, b) => a.registrationPlate
          .toLowerCase()
          .compareTo(b.registrationPlate.toLowerCase()));

      state = state.copyWith(
        status: BikeListStatus.success,
        bikes: bikesList,
      );
    } catch (e) {
      state = state.copyWith(
        status: BikeListStatus.failure,
        errorMessage: '${_appStrings.msgLoadFailed}: ${e.toString()}',
      );
    }
  }

  /// Triggers a refresh of the bike list.
  void refreshBikeList() {
    fetchBikes(isRefresh: true);
  }
}
