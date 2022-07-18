// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
import '../controllers/auth_controller.dart';

// States
import '../../shared/states/future_state.codegen.dart';

// Helpers
import '../../../helpers/constants/app_assets.dart';
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';
import '../../../helpers/constants/app_typography.dart';

// Routing
import '../../../config/routes/app_router.dart';

// Widgets
import '../../shared/widgets/custom_circular_loader.dart';
import '../../shared/widgets/custom_dialog.dart';
import '../../shared/widgets/custom_text_button.dart';

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
            Text(
              'Family Expense Tracker',
              style: AppTypography.primary.heading34.copyWith(
                fontSize: 45,
              ),
            ),

            Insets.gapH20,

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Save your money with\nconscious spending',
                style: AppTypography.primary.title18,
              ),
            ),

            Insets.expand,

            // Login Button
            CustomTextButton.gradient(
              width: double.infinity,
              gradient: AppColors.buttonGradientPurple,
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
                child: Center(
                  child: Text(
                    'GOOGLE SIGN IN',
                    style: AppTypography.secondary.body16.copyWith(
                      color: Colors.white,
                    ),
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
