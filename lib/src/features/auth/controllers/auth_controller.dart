import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../../all_providers.dart';

// Repositories
import '../repositories/auth_repository.dart';

// States
import '../../shared/states/future_state.codegen.dart';

final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, FutureState<bool?>>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class AuthController extends StateNotifier<FutureState<bool?>> {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const FutureState.idle());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const FutureState.loading();

    state = await FutureState.makeGuardedRequest(() async {
      await _authRepository.signUp(email: email, password: password);

      return true;
    });
  }

  Future<void> login() async {
    state = const FutureState.loading();

    state = await FutureState.makeGuardedRequest(() async {
      final credential = await _authRepository.createGoogleCredentials();
      await _authRepository.login(authCredential: credential);

      return true;
    });
  }

  void logout() {
    _authRepository.signOut();
    state = const FutureState.idle();
  }
}
