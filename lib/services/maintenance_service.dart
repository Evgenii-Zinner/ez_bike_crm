import '../utils/imports.dart';

/// Domain service for managing maintenance-related business logic.
///
/// Handles repair history, cost aggregation, and date-filtered lookups.
class MaintenanceService {
  final MaintenanceDbService _maintenanceDbService;

  MaintenanceService(this._maintenanceDbService);

  /// Retrieves a map of all maintenance logs.
  Future<Map<String, Maintenance>> getMaintenances() async {
    return await _maintenanceDbService.getMaintenances();
  }

  /// Finds a specific maintenance record by its [maintenanceId].
  Future<Maintenance?> getMaintenance(String maintenanceId) async {
    final maintenances = await _maintenanceDbService.getMaintenances();
    return maintenances.values.firstWhere(
        (maintenance) => maintenance.maintenanceId == maintenanceId);
  }

  /// Logs a new maintenance entry.
  Future<void> addMaintenance(Maintenance maintenance) async {
    await _maintenanceDbService.addMaintenance(maintenance);
  }

  /// Updates an existing maintenance record.
  Future<void> updateMaintenance(Maintenance maintenance) async {
    await _maintenanceDbService.updateMaintenance(maintenance);
  }

  /// Removes a maintenance record from the database.
  Future<void> removeMaintenance(String maintenanceId) async {
    await _maintenanceDbService.removeMaintenance(maintenanceId);
  }

  /// Returns all maintenance records associated with a specific bike registration plate.
  Future<Map<String, Maintenance>> getMaintenancesForBike(String bikeId) async {
    final allMaintenancesMap = await getMaintenances();
    allMaintenancesMap
        .removeWhere((key, maintenance) => maintenance.bikeId != bikeId);
    return allMaintenancesMap;
  }

  /// Returns all maintenance logs that occurred within a specific year.
  Future<Map<String, Maintenance>> getMaintenancesForYear(
      DateTime dateInYear) async {
    final DateTime firstDayOfYear = DateTime(dateInYear.year, 1, 1, 0, 0, 0);
    final DateTime lastDayOfYear =
        DateTime(dateInYear.year + 1, 1, 0, 23, 59, 59);
    final allMaintenancesMap = await getMaintenances();
    allMaintenancesMap.removeWhere((key, maintenance) =>
        maintenance.date.isAfter(lastDayOfYear) ||
        maintenance.date.isBefore(firstDayOfYear));
    return allMaintenancesMap;
  }

  /// Returns all maintenance logs that occurred within a specific month.
  Future<Map<String, Maintenance>> getMaintenancesForMonth(
      DateTime dateForMonth) async {
    final DateTime firstDayOfMonth =
        DateTime(dateForMonth.year, dateForMonth.month, 1, 0, 0, 0);
    final DateTime lastDayOfMonth =
        DateTime(dateForMonth.year, dateForMonth.month + 1, 0, 23, 59, 59);
    final allMaintenancesMap = await getMaintenances();
    allMaintenancesMap.removeWhere((key, maintenance) =>
        maintenance.date.isAfter(lastDayOfMonth) ||
        maintenance.date.isBefore(firstDayOfMonth));
    return allMaintenancesMap;
  }
}
