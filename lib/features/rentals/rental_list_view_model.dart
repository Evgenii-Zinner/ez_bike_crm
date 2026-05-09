import '../../utils/imports.dart';

/// Represents a combined item for display in the rental list.
class RentalListItem {
  /// The rental transaction data.
  final Rental rental;

  /// The associated customer data (if available).
  final Customer? customer;

  RentalListItem({required this.rental, this.customer});
}

/// Statuses for the rental list data fetching process.
enum RentalListStatus { initial, loading, success, failure }

/// State for the [RentalListScreen].
class RentalListState {
  /// The current status of the list fetch operation.
  final RentalListStatus status;

  /// List of rentals combined with customer info.
  final List<RentalListItem> items;

  /// Error message if the fetch failed.
  final String? errorMessage;

  const RentalListState({
    this.status = RentalListStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  /// Creates a copy of the state with updated fields.
  RentalListState copyWith({
    RentalListStatus? status,
    List<RentalListItem>? items,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RentalListState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel managing the history of all rental transactions.
///
/// Fetches rentals and customers concurrently, joins them into [RentalListItem]s,
/// and sorts them by start date (newest first).
class RentalListViewModel extends StateNotifier<RentalListState> {
  final Ref _ref;

  RentalListViewModel(this._ref) : super(const RentalListState()) {
    fetchRentals();
  }

  RentalService get _rentalService => _ref.read(rentalServiceProvider);

  CustomerService get _customerService => _ref.read(customerServiceProvider);

  AppLocalizations? get _appStrings => _ref.watch(localizationProvider);

  /// Fetches rentals and customers, joining them for display.
  Future<void> fetchRentals({bool isRefresh = false}) async {
    if (state.status == RentalListStatus.loading && !isRefresh) return;
    state = state.copyWith(
        status: RentalListStatus.loading, clearErrorMessage: true);
    try {
      // Concurrently fetch rentals and customers to build the combined list.
      final results = await Future.wait([
        _rentalService.getRentals(),
        _customerService.getCustomers(),
      ]);

      final rentalsMap = results[0] as Map<String, Rental>;
      final customersMap = results[1] as Map<String, Customer>;

      final rentalList = rentalsMap.values.toList();

      final List<RentalListItem> displayItems = rentalList.map((rental) {
        final customer = customersMap[rental.customerId];
        return RentalListItem(rental: rental, customer: customer);
      }).toList();

      // Sort rentals: newest first.
      displayItems
          .sort((a, b) => b.rental.startDate.compareTo(a.rental.startDate));

      state = state.copyWith(
        status: RentalListStatus.success,
        items: displayItems,
      );
    } catch (e) {
      state = state.copyWith(
        status: RentalListStatus.failure,
        errorMessage: '${_appStrings!.msgLoadFailed}: ${e.toString()}',
      );
    }
  }

  /// Triggers a data refresh.
  void refreshData() {
    fetchRentals(isRefresh: true);
  }
}
