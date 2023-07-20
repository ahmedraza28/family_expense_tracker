import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../../../global/widgets/widgets.dart';
import '../controllers/auth_controller.codegen.dart';

// Screens
import 'login_screen.dart';

// Features
import '../../books/books.dart';

class AuthWidgetBuilder extends HookConsumerWidget {
  const AuthWidgetBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(currentUserProvider),
      loading: () => const LoginScreen(),
      error: (_, __) => const LoginScreen(),
      data: (user) => user != null ? const BooksScreen() : const LoginScreen(),
    );
  }
}
