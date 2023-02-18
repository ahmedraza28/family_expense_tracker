import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../controllers/auth_controller.codegen.dart';

// Screens
import '../../home/screens/home_screen.dart';
import 'login_screen.dart';

class AuthWidgetBuilder extends HookConsumerWidget {
  const AuthWidgetBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);
    return authState.maybeWhen(
      data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
      orElse: () => const LoginScreen(),
    );
  }
}
