import 'package:equatable/equatable.dart';

/// User Events
/// Events untuk UserBloc

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all users from API
class FetchUsersEvent extends UserEvent {
  const FetchUsersEvent();
}

/// Load cached users from local storage
class LoadCachedUsersEvent extends UserEvent {
  const LoadCachedUsersEvent();
}

/// Create new user
class CreateUserEvent extends UserEvent {
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;

  const CreateUserEvent({
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
  });

  @override
  List<Object?> get props => [name, username, email, phone, website];
}

/// Delete user
class DeleteUserEvent extends UserEvent {
  final int id;

  const DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Clear user cache
class ClearUserCacheEvent extends UserEvent {
  const ClearUserCacheEvent();
}
