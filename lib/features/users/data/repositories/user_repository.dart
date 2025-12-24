import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';

/// User Repository
/// Repository untuk fetch dan post user data dengan caching

class UserRepository {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;

  UserRepository({DioClient? dioClient, LocalStorageService? localStorage})
    : _dioClient = dioClient ?? DioClient.instance,
      _localStorage = localStorage ?? LocalStorageService.instance;

  /// Fetch all users from API
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dioClient.get(ApiConstants.users);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final users = data.map((json) => UserModel.fromJson(json)).toList();

        // Cache users to local storage
        _cacheUsers(users);

        return users;
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      // Try to get cached data on error
      final cachedUsers = getCachedUsers();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers;
      }
      rethrow;
    }
  }

  /// Fetch single user by ID
  Future<UserModel> fetchUserById(int id) async {
    final response = await _dioClient.get('${ApiConstants.users}/$id');

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  /// Create new user (POST)
  Future<UserModel> createUser({
    required String name,
    required String username,
    required String email,
    String? phone,
    String? website,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.users,
      data: {
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'website': website,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }

  /// Update user (PUT)
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _dioClient.put(
      '${ApiConstants.users}/${user.id}',
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  /// Delete user
  Future<void> deleteUser(int id) async {
    final response = await _dioClient.delete('${ApiConstants.users}/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  /// Cache users to local storage
  void _cacheUsers(List<UserModel> users) {
    final usersJson = users.map((u) => u.toJson()).toList();
    _localStorage.setList(StorageKeys.cachedUsers, usersJson);
    _localStorage.setString(
      StorageKeys.lastFetchTime,
      DateTime.now().toIso8601String(),
    );
  }

  /// Get cached users from local storage
  List<UserModel> getCachedUsers() {
    final cachedData = _localStorage.getList(StorageKeys.cachedUsers);
    if (cachedData != null) {
      return cachedData
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get last fetch time
  DateTime? getLastFetchTime() {
    final timeStr = _localStorage.getString(StorageKeys.lastFetchTime);
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    return null;
  }

  /// Clear cached users
  void clearCache() {
    _localStorage.remove(StorageKeys.cachedUsers);
    _localStorage.remove(StorageKeys.lastFetchTime);
  }
}
