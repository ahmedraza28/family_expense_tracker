import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Providers
import '../../../core/core.dart';

// Repositories
import '../repositories/auth_repository.codegen.dart';

part 'auth_controller.codegen.g.dart';

final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  late final AuthRepository _authRepository;

  @override
  FutureOr<UserCredential?> build() {
    _authRepository = ref.read(authRepositoryProvider);
    return null;
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() {
      return _authRepository.signUp(email: email, password: password);
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() async {
      final credential = await _authRepository.createGoogleCredentials();
      if (credential != null) {
        return _authRepository.login(authCredential: credential);
      }
      return null;
    });
  }

  void logout() {
    _authRepository.signOut();
    state = const AsyncValue.data(null);
  }
}
