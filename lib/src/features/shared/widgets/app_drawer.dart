import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'share_access_qr_button.dart';
import 'shaded_icon.dart';

// Features
import '../../auth/auth.dart';
import '../../books/books.dart';

final selectedRouteProvider = StateProvider<String>(
  (ref) => Routes.TransactionsScreenRoute,
);

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Info and Share access code button
          SizedBox(
            height: 163,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info
                  Consumer(
                    builder: (context, ref, child) {
                      final currentUser = ref.watch(currentUserProvider).value!;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CustomNetworkImage(
                          imageUrl: currentUser.imageUrl ?? '',
                          width: 40,
                          height: 40,
                          shape: BoxShape.circle,
                          errorWidget: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomText.title(
                                currentUser.displayName[0],
                                fontSize: 18,
                                color: AppColors.textWhite80Color,
                              ),
                            ),
                          ),
                        ),
                        title: CustomText.body(
                          currentUser.displayName.toUpperCase(),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: CustomText.subtitle(
                          currentUser.email,
                        ),
                      );
                    },
                  ),

                  // Share access code button
                  const ShareAccessQRButton(),
                ],
              ),
            ),
          ),

          // Book Details
          Consumer(
            builder: (context, ref, child) {
              final book = ref.watch(selectedBookProvider)!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListTile(
                  onTap: AppRouter.popUntilRoot,
                  minVerticalPadding: 0,
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
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.menu_rounded,
                    color: book.color,
                  ),
                ),
              );
            },
          ),

          // Divider
          const Divider(height: 0),

          // Transactions
          Consumer(
            builder: (context, ref, child) {
              const route = Routes.TransactionsScreenRoute;
              final isSelected = ref.watch(
                selectedRouteProvider.select((value) => value == route),
              );
              return ListTile(
                onTap: () {
                  ref.read(selectedRouteProvider.notifier).state = route;
                  AppRouter.pushReplacementNamed(route);
                },
                minVerticalPadding: 15,
                leading: Icon(
                  Icons.money,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
                minLeadingWidth: 30,
                title: CustomText(
                  'Transactions',
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
              );
            },
          ),

          // Wallets
          Consumer(
            builder: (context, ref, child) {
              const route = Routes.WalletsScreenRoute;
              final isSelected = ref.watch(
                selectedRouteProvider.select((value) => value == route),
              );
              return ListTile(
                onTap: () {
                  ref.read(selectedRouteProvider.notifier).state = route;
                  AppRouter.pushReplacementNamed(route);
                },
                minVerticalPadding: 15,
                leading: Icon(
                  Icons.wallet_rounded,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
                minLeadingWidth: 30,
                title: CustomText(
                  'Wallets',
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
              );
            },
          ),

          // Categories
          Consumer(
            builder: (context, ref, child) {
              const route = Routes.CategoriesScreenRoute;
              final isSelected = ref.watch(
                selectedRouteProvider.select((value) => value == route),
              );
              return ListTile(
                onTap: () {
                  ref.read(selectedRouteProvider.notifier).state = route;
                  AppRouter.pushReplacementNamed(route);
                },
                minVerticalPadding: 15,
                leading: Icon(
                  Icons.category_rounded,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
                minLeadingWidth: 30,
                title: CustomText(
                  'Categories',
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
              );
            },
          ),

          // Budgets
          Consumer(
            builder: (context, ref, child) {
              const route = Routes.BudgetsScreenRoute;
              final isSelected = ref.watch(
                selectedRouteProvider.select((value) => value == route),
              );
              return ListTile(
                onTap: () {
                  ref.read(selectedRouteProvider.notifier).state = route;
                  AppRouter.pushReplacementNamed(route);
                },
                minVerticalPadding: 15,
                leading: Icon(
                  Icons.money_off_rounded,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
                minLeadingWidth: 30,
                title: CustomText(
                  'Budgets',
                  fontSize: 16,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textGreyColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
