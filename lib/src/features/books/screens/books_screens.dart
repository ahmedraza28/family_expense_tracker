import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../../shared/shared.dart';
import '../widgets/add_book_fab.dart';
import '../widgets/scan_invite_fab.dart';
import 'books_view.dart';
import 'add_edit_book_screen.dart';

// Features
import '../../auth/auth.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Books',
          fontSize: 20,
        ),
        leading: RotatedBox(
          quarterTurns: 2,
          child: InkResponse(
            radius: 26,
            child: const Icon(
              Icons.logout,
              color: AppColors.primaryColor,
            ),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ),
      ),
      body: const BooksView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 55,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scan Code fab
            OpenContainer(
              openElevation: 0,
              closedElevation: 5,
              transitionType: ContainerTransitionType.fadeThrough,
              closedColor: AppColors.primaryColor,
              middleColor: AppColors.lightPrimaryColor,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              tappable: false,
              transitionDuration: Durations.medium,
              closedBuilder: (ctx, openFunction) => SizedBox(
                height: 55,
                child: ScanInviteFab(onPressed: openFunction),
              ),
              openBuilder: (ctx, closeFunction) => QrScannerScreen(
                onPressed: closeFunction,
              ),
            ),

            // Divider
            const VerticalDivider(
              color: Colors.white,
              thickness: 1,
              width: 1,
            ),

            // Add book fab
            OpenContainer(
              openElevation: 0,
              closedElevation: 5,
              transitionType: ContainerTransitionType.fadeThrough,
              closedColor: AppColors.primaryColor,
              middleColor: AppColors.lightPrimaryColor,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              tappable: false,
              transitionDuration: Durations.medium,
              closedBuilder: (ctx, openFunction) => AddBookFab(
                onPressed: openFunction,
              ),
              openBuilder: (ctx, closeFunction) => AddEditBookScreen(
                onPressed: closeFunction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
