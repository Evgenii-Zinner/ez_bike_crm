import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils/imports.dart';

/// A service that provides a wrapper around the Firebase Realtime Database.
///
/// This service implements a custom local caching layer to reduce network
/// requests and improve UI responsiveness. It manages user-specific data
/// paths and handles CRUD operations with automatic cache synchronization.
class DatabaseService extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// In-memory cache to store entity data.
  /// Structure: { 'entityPath': { 'itemId': { data } } }
  final Map<String, Map<String, dynamic>> _cache = {};

  String? get _uid => _auth.currentUser?.uid;

  /// Returns a user-specific database path to ensure data isolation.
  String _userSpecificPath(String entityPath) =>
      _uid == null ? '' : 'users/$_uid/$entityPath';

  /// Updates the entire cache for a specific entity.
  void _updateCache(String entityPath, Map<String, dynamic> data) {
    _cache[entityPath] = data;
    notifyListeners();
  }

  /// Updates or adds a single item in the entity's cache.
  void _updateCachedItem(
      String entityPath, String itemId, Map<String, dynamic> itemData) {
    if (_cache.containsKey(entityPath)) {
      _cache[entityPath]![itemId] = itemData;
    }
    notifyListeners();
  }

  /// Removes an item from the entity's cache.
  void _deleteCachedItem(String entityPath, String itemId) {
    if (_cache.containsKey(entityPath)) {
      _cache[entityPath]!.remove(itemId);
    }
    notifyListeners();
  }

  /// Clears all cached data, typically used on logout.
  void clearAllCache() {
    _cache.clear();
    notifyListeners();
  }

  /// Creates a new entry in the database.
  /// If [id] is provided, it uses it as the key; otherwise, it pushes a new key.
  Future<String> create(String entityPath, Map<String, dynamic> data,
      {String? id}) async {
    if (id == null) {
      final ref = _db.child(_userSpecificPath(entityPath)).push();
      await ref.set(data);
      _updateCachedItem(entityPath, ref.key!, data);
      return ref.key!;
    } else {
      final fullPath = _userSpecificPath('$entityPath/$id');
      await _db.child(fullPath).set(data);
      _updateCachedItem(entityPath, id, data);
      return id;
    }
  }

  /// Reads all items for a given entity path.
  /// Returns cached data unless [forceRefresh] is true.
  Future<Map<String, dynamic>> readAll(String entityPath,
      {bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.containsKey(entityPath)) {
      return Map<String, dynamic>.from(_cache[entityPath]!);
    }
    final fullPath = _userSpecificPath(entityPath);
    final snapshot = await _db.child(fullPath).get();
    if (snapshot.exists && snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;
      final processedMap = map.map((k, v) =>
          MapEntry(k.toString(), Map<String, dynamic>.from(v as Map)));
      _updateCache(entityPath, processedMap);
      return Map<String, dynamic>.from(processedMap);
    }
    _updateCache(entityPath, {});
    return {};
  }

  /// Reads a single item by ID.
  /// Returns cached data if available unless [forceRefresh] is true.
  Future<Map<String, dynamic>?> read(String entityPath, String id,
      {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _cache.containsKey(entityPath) &&
        _cache[entityPath]!.containsKey(id)) {
      return Map<String, dynamic>.from(_cache[entityPath]![id]!);
    }
    final fullPath = _userSpecificPath('$entityPath/$id');
    final snapshot = await _db.child(fullPath).get();
    if (snapshot.exists && snapshot.value != null) {
      final itemData = Map<String, dynamic>.from(snapshot.value as Map);
      _updateCachedItem(entityPath, id, itemData);
      return itemData;
    }
    return null;
  }

  /// Updates an existing entry in the database.
  Future<void> update(
      String entityPath, String id, Map<String, dynamic> data) async {
    final fullPath = _userSpecificPath('$entityPath/$id');
    if (fullPath.isEmpty || id.isEmpty) return;
    await _db.child(fullPath).update(data);
    _updateCachedItem(entityPath, id, data);
  }

  /// Removes an entry from the database.
  Future<void> remove(String entityPath, String id) async {
    final fullPath = _userSpecificPath('$entityPath/$id');
    await _db.child(fullPath).remove();
    _deleteCachedItem(entityPath, id);
  }
}
