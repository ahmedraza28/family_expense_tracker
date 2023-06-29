import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/user_model.codegen.dart';

// Repositories
import '../repositories/users_repository.codegen.dart';

@immutable
class UserProviderParams extends Equatable {
  final List<String> userIds;
  const UserProviderParams(this.userIds);

  @override
  List<Object?> get props => [userIds];
}

final usersProvider =
    StreamProvider.family<List<UserModel>, UserProviderParams>((ref, params) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return usersRepository.getUsers(params.userIds);
});
