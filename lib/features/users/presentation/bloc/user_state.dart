import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

/// User States
/// States untuk UserBloc

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

/// Loading state - saat fetch atau post data
class UserLoading extends UserState {
  final String? message;

  const UserLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Loaded state - data berhasil di-fetch
class UserLoaded extends UserState {
  final List<UserModel> users;
  final bool isFromCache;
  final DateTime? lastFetchTime;

  const UserLoaded({
    required this.users,
    this.isFromCache = false,
    this.lastFetchTime,
  });

  @override
  List<Object?> get props => [users, isFromCache, lastFetchTime];
}

/// Error state
class UserError extends UserState {
  final String message;
  final List<UserModel>? cachedUsers;

  const UserError({required this.message, this.cachedUsers});

  @override
  List<Object?> get props => [message, cachedUsers];
}

/// User created successfully
class UserCreated extends UserState {
  final UserModel user;

  const UserCreated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User deleted successfully
class UserDeleted extends UserState {
  final int userId;

  const UserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Cache cleared
class UserCacheCleared extends UserState {
  const UserCacheCleared();
}
