import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../auth/auth.dart';

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

            Insets.gapH20,

            // User Details
            // const UserProfileDetails(),

            Insets.gapH30,

            // Screens list
            const Expanded(
              child: ScreensList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreensList extends StatelessWidget {
  const ScreensList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Books
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          onTap: () {
            AppRouter.pushNamed(Routes.BooksScreenRoute);
          },
          leading: const Icon(
            Icons.book,
            color: AppColors.primaryColor,
            size: 40,
          ),
          title: const CustomText(
            'Books',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          subtitle: const CustomText(
            'View your books',
            fontSize: 16,
          ),
        ),

        Insets.gapH20,

        // Wallets
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          onTap: () {
            AppRouter.pushNamed(Routes.WalletsScreenRoute);
          },
          leading: const Icon(
            Icons.account_balance_wallet,
            color: AppColors.primaryColor,
            size: 40,
          ),
          title: const CustomText(
            'Wallets',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          subtitle: const CustomText(
            'View your wallets',
            fontSize: 16,
          ),
        ),

        Insets.gapH20,

        // Transactions
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          onTap: () {
            AppRouter.pushNamed(Routes.TransactionsScreenRoute);
          },
          leading: const Icon(
            Icons.money,
            color: AppColors.primaryColor,
            size: 40,
          ),
          title: const CustomText(
            'Transactions',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          subtitle: const CustomText(
            'View your transactions',
            fontSize: 16,
          ),
        ),

        Insets.gapH20,

        // Categories
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          onTap: () {
            AppRouter.pushNamed(Routes.CategoriesScreenRoute);
          },
          leading: const Icon(
            Icons.category,
            color: AppColors.primaryColor,
            size: 40,
          ),
          title: const CustomText(
            'Categories',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          subtitle: const CustomText(
            'View your categories',
            fontSize: 16,
          ),
        ),

        Insets.gapH20,

        // Budgets
        ListTile(
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          onTap: () {
            AppRouter.pushNamed(Routes.BudgetsScreenRoute);
          },
          leading: const Icon(
            Icons.money_off,
            color: AppColors.primaryColor,
            size: 40,
          ),
          title: const CustomText(
            'Budgets',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          subtitle: const CustomText(
            'View your budgets',
            fontSize: 16,
          ),
        ),

        Insets.gapH20,
      ],
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
      children: [
        // Full Name Label
        const CustomText(
          'Full Name',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),

        // Full Name
        CustomText.title(
          currentUser.displayName,
        ),

        Insets.gapH20,

        // Email Label
        const CustomText(
          'Email',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),

        // Email Data
        CustomText.title(
          currentUser.email,
        ),
      ],
    );
  }
}
