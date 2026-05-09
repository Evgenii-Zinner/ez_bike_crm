import 'package:url_launcher/url_launcher.dart';

import '../../utils/imports.dart';

/// Possible statuses for the [CustomerListScreen] data fetching process.
enum CustomerListStatus { initial, loading, success, failure }

/// State for the [CustomerListScreen].
///
/// Contains the list of customers to display and the current status of the
/// fetching operation.
class CustomerListState {
  /// The current status of the customer list fetching operation.
  final CustomerListStatus status;

  /// The list of customers to display.
  final List<Customer> customers;

  /// An optional error message to display if the fetch operation fails.
  final String? errorMessage;

  const CustomerListState({
    this.status = CustomerListStatus.initial,
    this.customers = const [],
    this.errorMessage,
  });

  /// Creates a copy of the current state with the given fields replaced.
  CustomerListState copyWith({
    CustomerListStatus? status,
    List<Customer>? customers,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CustomerListState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// View model for the [CustomerListScreen].
///
/// Manages the list of customers, handles data fetching through the
/// [CustomerService], and provides a method to launch phone calls.
class CustomerListViewModel extends StateNotifier<CustomerListState> {
  final Ref _ref;

  CustomerListViewModel(this._ref) : super(const CustomerListState()) {
    fetchCustomers();
  }

  CustomerService get _customerService => _ref.read(customerServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  /// Fetches the list of customers from the database.
  ///
  /// If [isRefresh] is true, the fetch operation will be forced.
  Future<void> fetchCustomers({bool isRefresh = false}) async {
    if (state.status == CustomerListStatus.loading && !isRefresh) return;

    state = state.copyWith(
        status: CustomerListStatus.loading, clearErrorMessage: true);
    try {
      final customersMap = await _customerService.getCustomers();
      final customersList = customersMap.values.toList();

      state = state.copyWith(
        status: CustomerListStatus.success,
        customers: customersList,
      );
    } catch (e) {
      state = state.copyWith(
        status: CustomerListStatus.failure,
        errorMessage: 'Failed to load customers: ${e.toString()}',
      );
    }
  }

  /// Triggers a refresh of the customer list.
  void refreshCustomerList() {
    fetchCustomers(isRefresh: true);
  }

  /// Launches a phone call to the specified [phoneNumber].
  ///
  /// Uses the `url_launcher` package to initiate the call.
  Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        state = state.copyWith(
            errorMessage: '${_appStrings.msgPhoneLaunchFailed} $phoneNumber');
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: '${_appStrings.msgPhoneLaunchFailed} $phoneNumber: $e');
    }
  }
}
