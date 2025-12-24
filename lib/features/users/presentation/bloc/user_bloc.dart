import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

/// User BLoC
/// BLoC untuk mengelola state user dengan contoh:
/// - Loading state
/// - Fetch data dari API
/// - Post data ke API
/// - Caching ke local storage

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository(),
      super(const UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<LoadCachedUsersEvent>(_onLoadCachedUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<ClearUserCacheEvent>(_onClearCache);
  }

  /// Handle fetch users event
  /// 1. Emit loading state
  /// 2. Load cached data first (optional)
  /// 3. Fetch from API
  /// 4. Data akan di-cache otomatis di repository
  /// 5. Emit loaded state
  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    // Emit loading state
    emit(const UserLoading(message: 'Mengambil data users...'));

    try {
      // Fetch from API (repository akan cache otomatis)
      final users = await _userRepository.fetchUsers();
      final lastFetchTime = _userRepository.getLastFetchTime();

      // Emit loaded state
      emit(
        UserLoaded(
          users: users,
          isFromCache: false,
          lastFetchTime: lastFetchTime,
        ),
      );
    } catch (e) {
      // Try to get cached data on error
      final cachedUsers = _userRepository.getCachedUsers();

      emit(
        UserError(
          message: 'Gagal mengambil data: ${e.toString()}',
          cachedUsers: cachedUsers.isNotEmpty ? cachedUsers : null,
        ),
      );
    }
  }

  /// Handle load cached users event
  /// Berguna untuk menampilkan data cached saat app start
  Future<void> _onLoadCachedUsers(
    LoadCachedUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Memuat data tersimpan...'));

    try {
      final cachedUsers = _userRepository.getCachedUsers();
      final lastFetchTime = _userRepository.getLastFetchTime();

      if (cachedUsers.isNotEmpty) {
        emit(
          UserLoaded(
            users: cachedUsers,
            isFromCache: true,
            lastFetchTime: lastFetchTime,
          ),
        );
      } else {
        // Tidak ada cache, fetch dari API
        add(const FetchUsersEvent());
      }
    } catch (e) {
      emit(UserError(message: 'Gagal memuat cache: ${e.toString()}'));
    }
  }

  /// Handle create user event (POST)
  /// 1. Emit loading state
  /// 2. POST ke API
  /// 3. Emit success state
  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Membuat user baru...'));

    try {
      final newUser = await _userRepository.createUser(
        name: event.name,
        username: event.username,
        email: event.email,
        phone: event.phone,
        website: event.website,
      );

      emit(UserCreated(newUser));

      // Refetch users to update list
      add(const FetchUsersEvent());
    } catch (e) {
      emit(UserError(message: 'Gagal membuat user: ${e.toString()}'));
    }
  }

  /// Handle delete user event
  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Menghapus user...'));

    try {
      await _userRepository.deleteUser(event.id);
      emit(UserDeleted(event.id));

      // Refetch users to update list
      add(const FetchUsersEvent());
    } catch (e) {
      emit(UserError(message: 'Gagal menghapus user: ${e.toString()}'));
    }
  }

  /// Handle clear cache event
  Future<void> _onClearCache(
    ClearUserCacheEvent event,
    Emitter<UserState> emit,
  ) async {
    _userRepository.clearCache();
    emit(const UserCacheCleared());
  }
}
