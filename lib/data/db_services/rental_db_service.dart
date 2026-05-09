import '../../utils/imports.dart';

/// Repository service for managing [Rental] transactions in the database.
///
/// Handles CRUD operations for tracking bike rentals, return dates, and deposits.
class RentalDbService {
  final DatabaseService _db;
  final String _path = 'rentals';

  RentalDbService(this._db);

  /// Creates a new [Rental] record and returns the generated transaction ID.
  Future<String> addRental(Rental rental) async {
    return await _db.create(_path, rental.toJson());
  }

  /// Retrieves all rental records from the database.
  ///
  /// Returns a map where the key is the rental ID and the value is the [Rental] object.
  Future<Map<String, Rental>> getRentals() async {
    final data = await _db.readAll(_path);
    return data.map((key, value) => MapEntry(key, Rental.fromJson(key, value)));
  }

  /// Retrieves a specific rental record by its [rentalId].
  Future<Rental?> getRental(String rentalId) async {
    final data = await _db.read(_path, rentalId);
    return data != null ? Rental.fromJson(rentalId, data) : null;
  }

  /// Updates an existing rental transaction (e.g., when a bike is returned).
  Future<void> updateRental(Rental rental) async {
    await _db.update(_path, rental.rentalId, rental.toJson());
  }

  /// Removes a rental record from the database.
  Future<void> removeRental(String rentalId) async {
    await _db.remove(_path, rentalId);
  }
}
