import '../../utils/imports.dart';

/// Repository service for managing [Customer] entities in the database.
///
/// Handles CRUD operations for customer records, utilizing Firebase
/// generated IDs or existing customer identifiers.
class CustomerDbService {
  final DatabaseService _db;
  final String _path = 'customers';

  CustomerDbService(this._db);

  /// Creates a new [Customer] record and returns the generated ID.
  Future<String> addCustomer(Customer customer) async {
    return await _db.create(_path, customer.toJson());
  }

  /// Retrieves all customers from the database.
  ///
  /// Returns a map where the key is the customer ID and the value is the [Customer] object.
  Future<Map<String, Customer>> getCustomers() async {
    final data = await _db.readAll(_path);
    return data
        .map((key, value) => MapEntry(key, Customer.fromJson(key, value)));
  }

  /// Retrieves a specific customer by their [customerId].
  Future<Customer?> getCustomer(String customerId) async {
    final data = await _db.read(_path, customerId);
    return data != null ? Customer.fromJson(customerId, data) : null;
  }

  /// Updates an existing customer's details.
  Future<void> updateCustomer(Customer customer) async {
    await _db.update(_path, customer.customerId, customer.toJson());
  }

  /// Removes a customer record from the database.
  Future<void> removeCustomer(String customerId) async {
    await _db.remove(_path, customerId);
  }
}
