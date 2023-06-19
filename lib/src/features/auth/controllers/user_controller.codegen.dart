import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/user_model.codegen.dart';

// Repositories
import '../repositories/users_repository.codegen.dart';

final usersProvider =
    StreamProvider.family<List<UserModel>, List<String>>((ref, userIds) {
  final usersRepository = ref.read(usersRepositoryProvider);
  return usersRepository.getUsers(userIds);
});
