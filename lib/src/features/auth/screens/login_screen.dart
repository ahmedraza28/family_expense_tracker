// ignore_for_file: avoid_positional_boolean_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../controllers/auth_controller.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<UserCredential?>>(
      authControllerProvider,
      (_, authState) => authState.whenOrNull(
        error: (reason, st) => CustomDialog.showAlertDialog(
          context: context,
          reason: reason as String,
          dialogTitle: 'Login Failed',
        ),
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Insets.gapH30,

            SvgPicture.asset(
              AppAssets.savingsPoster,
              height: 300,
              fit: BoxFit.fitWidth,
            ),

            Insets.gapH10,

            // Logo
            const CustomText(
              'Family Expense Tracker',
              maxLines: 2,
              fontSize: 45,
            ),

            Insets.gapH20,

            Align(
              alignment: Alignment.centerLeft,
              child: CustomText.title(
                'Save your money with\nconscious spending',
              ),
            ),

            Insets.expand,

            // Login Button
            CustomTextButton.gradient(
              width: double.infinity,
              gradient: AppColors.buttonGradientPrimary,
              onPressed: () {
                ref.read(authControllerProvider.notifier).loginWithGoogle();
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(authControllerProvider);
                  return state.maybeWhen(
                    loading: () => const CustomCircularLoader(
                      color: Colors.white,
                    ),
                    orElse: () => child!,
                  );
                },
                child: const Center(
                  child: CustomText(
                    'GOOGLE SIGN IN',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Insets.bottomInsetsLow,
          ],
        ),
      ),
    );
  }
}
