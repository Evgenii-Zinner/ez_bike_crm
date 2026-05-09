import '../utils/imports.dart';

/// Service responsible for managing the lifecycle of bike rentals.
///
/// This includes creating new rentals, processing returns, tracking deposits,
/// and calculating financial summaries. It acts as a bridge between the
/// UI/ViewModels and the [RentalDbService].
class RentalService {
  final RentalDbService _rentalDbService;

  RentalService(this._rentalDbService);

  /// Retrieves all rentals from the database.
  Future<Map<String, Rental>> getRentals() async {
    return await _rentalDbService.getRentals();
  }

  /// Finds a specific rental by its ID.
  Future<Rental?> getRental(String rentalId) async {
    final rental = await _rentalDbService.getRentals();
    return rental.values.firstWhere((rental) => rental.rentalId == rentalId);
  }

  /// Initiates a new rental entry.
  Future<String> addRental(Rental rental) async {
    String newRentalId = await _rentalDbService.addRental(rental);
    return newRentalId;
  }

  /// Updates an existing rental's information.
  Future<void> updateRental(Rental rental) async {
    await _rentalDbService.updateRental(rental);
  }

  /// Removes a rental record from the database.
  Future<void> removeRental(String rentalId) async {
    await _rentalDbService.removeRental(rentalId);
  }

  /// Returns all rentals associated with a specific bike registration plate.
  Future<Map<String, Rental>> getRentalsForBike(String bikeId) async {
    final allRentalsMap = await getRentals();
    allRentalsMap.removeWhere((key, rental) => rental.bikeId != bikeId);
    return allRentalsMap;
  }

  /// Returns all rentals associated with a specific customer.
  Future<Map<String, Rental>> getRentalsForCustomer(String customerId) async {
    final allRentalsMap = await getRentals();
    allRentalsMap.removeWhere((key, rental) => rental.customerId != customerId);
    return allRentalsMap;
  }

  /// Returns all rentals that were active during a specific month.
  Future<Map<String, Rental>> getRentalsForMonth(DateTime date) async {
    final DateTime startDate = DateTime(date.year, date.month, 1, 0, 0, 0);
    final DateTime endDate = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    final allRentalsMap = await getRentals();
    allRentalsMap.removeWhere((key, rental) =>
        rental.endDate.isBefore(startDate) ||
        rental.startDate.isAfter(endDate));
    return allRentalsMap;
  }

  /// Returns all rentals that were active during a specific year.
  Future<Map<String, Rental>> getRentalsForYear(DateTime dateInYear) async {
    final DateTime firstDayOfYear = DateTime(dateInYear.year, 1, 1, 0, 0, 0);
    final DateTime lastDayOfYear =
        DateTime(dateInYear.year + 1, 1, 0, 23, 59, 59);
    final allRentalsMap = await getRentals();
    allRentalsMap.removeWhere((key, rental) =>
        rental.startDate.isAfter(lastDayOfYear) ||
        rental.endDate.isBefore(firstDayOfYear));
    return allRentalsMap;
  }

  /// Calculates total deposits held and the count of documents held across all active rentals.
  Future<({double deposits, int documents})> getDepositsAmount() async {
    final allRentalsMap = await getRentals();
    double depositsAmount = 0.0;
    int documentsHeld = 0;
    allRentalsMap.forEach((key, rental) {
      if (rental.returnDate == null) {
        depositsAmount += rental.depositAmount;
        documentsHeld += rental.documentDepositProvided ? 1 : 0;
      }
    });
    return (deposits: depositsAmount, documents: documentsHeld);
  }
}
