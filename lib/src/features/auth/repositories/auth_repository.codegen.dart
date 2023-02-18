import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return const AuthRepository();
  // return MockAuthRepository();
}

class AuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  const AuthRepository();

  Future<UserCredential> login({
    required AuthCredential authCredential,
  }) async {
    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<OAuthCredential?> createGoogleCredentials() async {
    // Trigger the authentication flow
    final googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    // Create a new credential
    if (googleAuth != null) {
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    }
    return null;
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
