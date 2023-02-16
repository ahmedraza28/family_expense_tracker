import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Controllers
import '../../auth/controllers/auth_controller.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

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
            CustomText.heading(
              'Welcome',
              color: AppColors.primaryColor,
              fontSize: 45,
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
        const CustomText(
          'Full Name',
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),

        // Full Name
        CustomText.title(
          currentUser.displayName!,
        ),

        Insets.expand,

        // Email Label
        const CustomText(
          'Email',
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),

        // Email Data
        CustomText.title(
          currentUser.email!,
        ),

        Insets.expand,

        // Phone Number Label
        const CustomText(
          'Phone Number',
          color: AppColors.primaryColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),

        // Phone Number Data
        CustomText.title(
          currentUser.phoneNumber ?? 'Not Added',
        ),

        Insets.expand,
      ],
    );
  }
}
