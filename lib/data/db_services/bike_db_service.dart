import '../../utils/imports.dart';

/// Repository service for managing [Bike] entities in the database.
///
/// Handles CRUD operations specifically for bike records, using the
/// registration plate as the primary identifier.
class BikeDbService {
  final DatabaseService _db;
  final String _path = 'bikes';

  BikeDbService(this._db);

  /// Persists a new [Bike] record.
  ///
  /// Uses the bike's [registrationPlate] as the document ID.
  Future<void> addBike(Bike bike) async {
    await _db.create(_path, bike.toJson(), id: bike.registrationPlate);
  }

  /// Retrieves all bikes from the database.
  ///
  /// Returns a map where the key is the registration plate and the value is the [Bike] object.
  Future<Map<String, Bike>> getBikes() async {
    final data = await _db.readAll(_path);
    return data.map((key, value) => MapEntry(key, Bike.fromJson(value)));
  }

  /// Retrieves a specific bike by its [plate] number.
  Future<Bike?> getBike(String plate) async {
    final data = await _db.read(_path, plate);
    return data != null ? Bike.fromJson(data) : null;
  }

  /// Updates an existing bike's details in the database.
  Future<void> updateBike(Bike bike) async {
    await _db.update(_path, bike.registrationPlate, bike.toJson());
  }

  /// Removes a bike record from the database using its [plate] number.
  Future<void> removeBike(String plate) async {
    await _db.remove(_path, plate);
  }
}
