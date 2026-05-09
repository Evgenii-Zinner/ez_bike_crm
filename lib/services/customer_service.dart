import '../utils/imports.dart';

/// Domain service for managing customer-related business logic.
///
/// It implements a basic local cache to minimize database reads during
/// navigation and selection.
class CustomerService {
  final CustomerDbService _customerDbService;

  Map<String, Customer>? _customers;
  Customer? _lastAddedCustomer;

  CustomerService(this._customerDbService);

  /// Retrieves a map of all customers, utilizing a local cache if available.
  Future<Map<String, Customer>> getCustomers() async {
    if (_customers != null) {
      return _customers!;
    }
    _customers = await _customerDbService.getCustomers();
    return _customers!;
  }

  /// Finds a specific customer by their [customerId].
  Future<Customer?> getCustomerById(String customerId) async {
    await getCustomers();
    return _customers?[customerId];
  }

  /// Adds a new customer and updates the local cache.
  Future<Customer> addCustomer(Customer customer) async {
    await _customerDbService.addCustomer(customer);
    _customers = await _customerDbService.getCustomers();
    _lastAddedCustomer = customer;
    return customer;
  }

  /// Updates an existing customer's details and refreshes the cache.
  Future<void> updateCustomer(Customer customer) async {
    await _customerDbService.updateCustomer(customer);
    _customers = await _customerDbService.getCustomers();
  }

  /// Removes a customer record and refreshes the cache.
  Future<void> removeCustomer(String customerId) async {
    await _customerDbService.removeCustomer(customerId);
    _customers = await _customerDbService.getCustomers();
  }

  /// Returns the most recently added customer (useful for on-the-fly creation).
  Customer? getLastAddedCustomer() {
    return _lastAddedCustomer;
  }
}
