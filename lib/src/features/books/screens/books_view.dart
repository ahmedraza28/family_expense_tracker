import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../global/widgets/widgets.dart';
import '../../../helpers/constants/constants.dart';

// Features
import '../../../helpers/extensions/extensions.dart';
import '../../auth/auth.dart';

// Widgets
import '../widgets/books_list.dart';

final currentBooksViewTabProvider =
    StateProvider.autoDispose<BooksViewTabs>((_) => BooksViewTabs.owned);

enum BooksViewTabs { owned, shared }

class BooksView extends ConsumerWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabView = ref.watch(currentBooksViewTabProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AsyncValueWidget(
        value: ref.watch(currentUserProvider),
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 70),
          child: CustomCircularLoader(),
        ),
        error: (error, st) => ErrorResponseHandler(
          error: error,
          retryCallback: () {},
          stackTrace: st,
        ),
        emptyOrNull: () => const EmptyStateWidget(
          height: 395,
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
          title: 'No user logged in yet',
          subtitle: 'Check back later',
        ),
        data: (currentUser) => Column(
          children: [
            // Filters
            CupertinoSlidingSegmentedControl<BooksViewTabs>(
              children: {
                BooksViewTabs.owned: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    BooksViewTabs.owned.sanitizedName,
                    style: TextStyle(
                      fontSize: 13,
                      color: currentTabView == BooksViewTabs.owned
                          ? AppColors.textWhite80Color
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
                BooksViewTabs.shared: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    BooksViewTabs.shared.sanitizedName,
                    style: TextStyle(
                      fontSize: 13,
                      color: currentTabView == BooksViewTabs.shared
                          ? AppColors.textWhite80Color
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              },
              padding: const EdgeInsets.all(5),
              thumbColor: AppColors.primaryColor,
              backgroundColor: Colors.white,
              groupValue: currentTabView,
              onValueChanged: (BooksViewTabs? newValue) {
                if (newValue != null) {
                  ref
                      .read(currentBooksViewTabProvider.notifier)
                      .update((state) => newValue);
                }
              },
            ),

            Insets.gapH15,

            // Books List
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                child: currentTabView == BooksViewTabs.owned
                    ? BooksList(
                        bookIds: currentUser!.ownedBookIds,
                      )
                    : BooksList(
                        bookIds: currentUser!.sharedBookIds,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
