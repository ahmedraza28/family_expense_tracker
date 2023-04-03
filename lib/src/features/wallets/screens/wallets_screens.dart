import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../config/routing/routing.dart';
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_wallet_fab.dart';
import '../widgets/wallets_list.dart';

// Screens
import 'add_edit_wallet_screen.dart';

// Features
import '../../shared/shared.dart';
import '../../books/books.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Wallets',
          fontSize: 20,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CustomTextButton.outlined(
              height: 35,
              width: 200,
              borderRadius: 10,
              onPressed: () {
                AppRouter.pushNamed(
                  Routes.AddEditBalanceTransferScreenRoute,
                );
              },
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              child: const Center(
                child: CustomText(
                  'Transfer Balance',
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: const WalletsList(),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isOwner = ref.watch(isOwnerSelectedBookProvider);
          return !isOwner
              ? Insets.shrink
              : OpenContainer(
                  openElevation: 0,
                  closedElevation: 5,
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedColor: AppColors.primaryColor,
                  middleColor: AppColors.lightPrimaryColor,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: Corners.rounded(50),
                  ),
                  tappable: false,
                  transitionDuration: Durations.medium,
                  closedBuilder: (ctx, openFunction) => AddWalletFab(
                    onPressed: openFunction,
                  ),
                  openBuilder: (ctx, closeFunction) => AddEditWalletScreen(
                    onPressed: closeFunction,
                  ),
                );
        },
      ),
    );
  }
}
