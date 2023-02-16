// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../controllers/auth_controller.dart';

// States
import '../../../global/states/states.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<FutureState<bool?>>(
      authControllerProvider,
      (_, authState) => authState.whenOrNull(
        failed: (reason) => CustomDialog.showAlertDialog(
          context: context,
          reason: reason,
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
            CustomText.heading(
              'Family Expense Tracker',
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
