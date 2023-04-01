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

part 'auth_controller.codegen.g.dart';

@Riverpod(keepAlive: true)
Stream<UserModel?> currentUser(CurrentUserRef ref) {
  return Stream.value(
    const UserModel(
      uid: '1',
      displayName: 'Abdur Rafay',
      email: 'a.rafaysaleem@gmail.com',
      imageUrl: '',
      ownedBookIds: [1, 10],
      sharedBookIds: [2],
    ),
  );
  // return ref.watch(firebaseAuthProvider).authStateChanges().map(
  //       (event) => UserModel.fromFirebaseUser(event!),
  //     );
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<UserCredential?> build() => null;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    state = await state.makeGuardedRequest(() {
      return authRepository.signUp(email: email, password: password);
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    state = await state.makeGuardedRequest(() async {
      final credential = await authRepository.createGoogleCredentials();
      if (credential != null) {
        return authRepository.login(authCredential: credential);
      }
      return null;
    });
  }

  void logout() {
    ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}
