import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Core
import '../../../core/core.dart';

// Models
import '../models/user_model.codegen.dart';

// Repositories
import '../repositories/auth_repository.codegen.dart';
import '../repositories/users_repository.codegen.dart';

part 'auth_controller.codegen.g.dart';

@Riverpod(keepAlive: true)
Stream<UserModel?> currentUser(CurrentUserRef ref) {
  final usersRepository = ref.read(usersRepositoryProvider);
  return ref
      .watch(firebaseAuthProvider)
      .authStateChanges()
      .asyncExpand((event) {
    if (event == null) return null;
    return usersRepository.getUserById(event.uid);
  });
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<UserCredential?> build() => null;

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    state = await state.makeGuardedRequest(() async {
      final credential = await authRepository.createGoogleCredentials();
      if (credential != null) {
        final userCred = await authRepository.login(authCredential: credential);

        // TODO(arafaysaleem): Move this to cloud function triggers
        final usersRepository = ref.read(usersRepositoryProvider);
        final user = userCred.user!;
        final userExists = await usersRepository.userExists(user.uid);

        if (!userExists) {
          await usersRepository.addUser(
            uid: user.uid,
            body: UserModel.fromFirebaseUser(user).toJson(),
          );
        }

        return userCred;
      }
      return null;
    });
  }

  void logout() {
    ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}
