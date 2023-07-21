// ignore_for_file: avoid_positional_boolean_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../../../helpers/extensions/object_extensions.dart';
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
      body: SafeArea(
        child: Padding(
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

              Insets.gapH20,

              // Logo
              const CustomText(
                'Family Expense Tracker',
                maxLines: 2,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),

              Insets.gapH20,

              const Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'Save your money with\nconscious spending',
                  fontSize: 22,
                ),
              ),

              Insets.expand,

              // Login Button
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.watch(authControllerProvider);
                  final userLoading = ref.watch(
                    currentUserProvider.select((value) => value.isLoading),
                  );
                  final isLoading = authState.isLoading ||
                      (authState.value.isNotNull && userLoading);
                  return CustomTextButton.gradient(
                    width: double.infinity,
                    gradient: AppColors.buttonGradientPrimary,
                    onPressed: () {
                      if (isLoading) return;
                      ref
                          .read(authControllerProvider.notifier)
                          .loginWithGoogle();
                    },
                    child: isLoading
                        ? const CustomCircularLoader(
                            color: Colors.white,
                          )
                        : child!,
                  );
                },
                child: const Center(
                  child: CustomText(
                    'GOOGLE SIGN IN',
                    color: Colors.white,
                  ),
                ),
              ),

              Insets.bottomInsetsLow,
            ],
          ),
        ),
      ),
    );
  }
}
