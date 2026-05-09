import '../../utils/imports.dart';

/// Repository service for managing [Maintenance] logs in the database.
///
/// Handles CRUD operations for tracking bike maintenance history and costs.
class MaintenanceDbService {
  final DatabaseService _db;
  final String _path = 'maintenances';

  MaintenanceDbService(this._db);

  /// Logs a new [Maintenance] entry and returns the generated ID.
  Future<String> addMaintenance(Maintenance maintenance) async {
    return await _db.create(_path, maintenance.toJson());
  }

  /// Retrieves all maintenance logs from the database.
  ///
  /// Returns a map where the key is the maintenance ID and the value is the [Maintenance] object.
  Future<Map<String, Maintenance>> getMaintenances() async {
    final data = await _db.readAll(_path);
    return data
        .map((key, value) => MapEntry(key, Maintenance.fromJson(key, value)));
  }

  /// Retrieves a specific maintenance log by its [maintenanceId].
  Future<Maintenance?> getMaintenance(String maintenanceId) async {
    final data = await _db.read(_path, maintenanceId);
    return data != null ? Maintenance.fromJson(maintenanceId, data) : null;
  }

  /// Updates an existing maintenance log.
  Future<void> updateMaintenance(Maintenance maintenance) async {
    await _db.update(_path, maintenance.maintenanceId, maintenance.toJson());
  }

  /// Removes a maintenance record from the database.
  Future<void> removeMaintenance(String maintenanceId) async {
    await _db.remove(_path, maintenanceId);
  }
}
