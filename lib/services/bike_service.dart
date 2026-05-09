import '../utils/imports.dart';

/// Domain service for managing bike-related business logic.
///
/// Acts as an abstraction layer over [BikeDbService] to handle high-level
/// fleet management operations.
class BikeService {
  final BikeDbService _bikeDbService;

  BikeService(this._bikeDbService);

  /// Retrieves a map of all bikes in the fleet.
  Future<Map<String, Bike>> getBikes() async {
    return await _bikeDbService.getBikes();
  }

  /// Retrieves a specific bike by its [bikeId].
  Future<Bike?> getBike(String bikeId) async {
    return _bikeDbService.getBike(bikeId);
  }

  /// Adds a new bike to the fleet.
  Future<void> addBike(Bike bike) async {
    await _bikeDbService.addBike(bike);
  }

  /// Updates an existing bike's information.
  Future<void> updateBike(Bike bike) async {
    await _bikeDbService.updateBike(bike);
  }

  /// Removes a bike from the fleet using its [registrationPlate].
  Future<void> removeBike(String registrationPlate) async {
    await _bikeDbService.removeBike(registrationPlate);
  }

  /// Returns a map of all existing registration plates for validation purposes.
  Future<Map<String, bool>> getExistingPlates() async {
    final bikes = await _bikeDbService.getBikes();
    return bikes.map((key, value) => MapEntry(key, true));
  }

  /// Filters and returns bikes based on their current availability [status].
  Future<Map<String, Bike>> getBikesByStatus(String status) async {
    final bikes = await _bikeDbService.getBikes();
    bikes.removeWhere((key, value) => value.bikeStatus != status);
    return bikes;
  }
}
