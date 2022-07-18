import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';
import '../../../helpers/constants/app_typography.dart';

// Routes
import '../../../config/routes/app_router.dart';

// Controllers
import '../../auth/controllers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 65),

            // Log out icon
            RotatedBox(
              quarterTurns: 2,
              child: InkResponse(
                radius: 26,
                child: const Icon(
                  Icons.logout,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                },
              ),
            ),

            const SizedBox(height: 20),

            // Welcome
            Text(
              'Welcome',
              style: AppTypography.primary.heading34.copyWith(
                color: AppColors.primaryColor,
                fontSize: 45,
              ),
            ),

            const SizedBox(height: 50),

            // User Details
            const Flexible(
              child: SizedBox(
                width: double.infinity,
                child: UserProfileDetails(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileDetails extends HookConsumerWidget {
  const UserProfileDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Full Name Label
        Text(
          'Full Name',
          style: AppTypography.primary.heading22.copyWith(
            color: AppColors.primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Full Name
        Text(
          currentUser.displayName!,
          style: AppTypography.primary.title18,
        ),

        Insets.expand,

        // Email Label
        Text(
          'Email',
          style: AppTypography.primary.heading22.copyWith(
            color: AppColors.primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Email Data
        Text(
          currentUser.email!,
          style: AppTypography.primary.title18,
        ),

        Insets.expand,

        // Phone Number Label
        Text(
          'Phone Number',
          style: AppTypography.primary.heading22.copyWith(
            color: AppColors.primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Phone Number Data
        Text(
          currentUser.phoneNumber ?? 'Not Added',
          style: AppTypography.primary.title18,
        ),

        Insets.expand,
      ],
    );
  }
}
