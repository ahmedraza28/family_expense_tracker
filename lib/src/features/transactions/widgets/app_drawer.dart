import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/routing/routing.dart';
import '../../../global/widgets/widgets.dart';
import '../../../helpers/constants/constants.dart';
import '../../books/books.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              child: Text('User Info Here'),
            ),
          ),

          // Book Details
          Consumer(
            builder: (context, ref, child) {
              final book = ref.watch(selectedBookProvider)!;
              return ListTile(
                onTap: () {
                  ref.invalidate(selectedBookProvider);
                  AppRouter.pop();
                },
                minVerticalPadding: 10,
                title: Row(
                  children: [
                    // Book Icon
                    ShadedIcon(
                      color: book.color,
                      iconData: Icons.menu_book_rounded,
                    ),

                    Insets.gapW15,

                    // Book Name
                    CustomText.body(
                      book.name,
                      fontSize: 18,
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.menu_rounded,
                  color: book.color,
                ),
              );
            },
          ),

          // Divider
          const Divider(height: 0),

          // Transactions
          ListTile(
            onTap: () {
              AppRouter.pushReplacementNamed(Routes.TransactionsScreenRoute);
            },
            minVerticalPadding: 15,
            leading: const Icon(
              Icons.money,
              color: AppColors.primaryColor,
            ),
            minLeadingWidth: 30,
            title: const CustomText(
              'Transactions',
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),

          // Wallets
          ListTile(
            onTap: () {
              AppRouter.pushReplacementNamed(Routes.WalletsScreenRoute);
            },
            minVerticalPadding: 15,
            leading: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.textGreyColor,
            ),
            minLeadingWidth: 30,
            title: const CustomText(
              'Wallets',
              fontSize: 16,
              color: AppColors.textGreyColor,
            ),
          ),

          // Categories
          ListTile(
            onTap: () {
              AppRouter.pushReplacementNamed(Routes.CategoriesScreenRoute);
            },
            minVerticalPadding: 15,
            leading: const Icon(
              Icons.category_rounded,
              color: AppColors.textGreyColor,
            ),
            minLeadingWidth: 30,
            title: const CustomText(
              'Categories',
              fontSize: 16,
              color: AppColors.textGreyColor,
            ),
          ),

          // Budgets
          ListTile(
            onTap: () {
              AppRouter.pushReplacementNamed(Routes.BudgetsScreenRoute);
            },
            minVerticalPadding: 15,
            leading: const Icon(
              Icons.money_off_rounded,
              color: AppColors.textGreyColor,
            ),
            minLeadingWidth: 30,
            title: const CustomText(
              'Budgets',
              fontSize: 16,
              color: AppColors.textGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
