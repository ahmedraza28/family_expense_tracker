import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../global/widgets/widgets.dart';
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Features
import '../../auth/auth.dart';

// Widgets
import '../widgets/books_list.dart';

class BooksView extends ConsumerStatefulWidget {
  const BooksView({super.key});

  @override
  ConsumerState<BooksView> createState() => BooksViewState();
}

class BooksViewState extends ConsumerState<BooksView> {
  int _selectedSegmentValue = 0;

  @override
  Widget build(BuildContext context) {
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
            // Scan Invite Code Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CustomTextButton(
                  height: 36,
                  width: 176,
                  borderRadius: 100,
                  onPressed: () {
                    AppRouter.pushNamed(Routes.QrScannerScreenRoute);
                  },
                  color: AppColors.textBlueGreyColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.subtitle(
                        'Scan access code',
                        color: AppColors.textBlackColor,
                      ),
                      Insets.gapW5,
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 18,
                        color: AppColors.textBlackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Insets.gapH15,

            // Filters
            CupertinoSlidingSegmentedControl(
              children: {
                0: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Owned',
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedSegmentValue == 0
                          ? AppColors.textWhite80Color
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
                1: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Shared',
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedSegmentValue == 1
                          ? AppColors.textWhite80Color
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              },
              padding: const EdgeInsets.all(5),
              thumbColor: AppColors.primaryColor,
              backgroundColor: Colors.white,
              groupValue: _selectedSegmentValue,
              onValueChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSegmentValue = newValue;
                  });
                }
              },
            ),

            Insets.gapH15,

            // Books List
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                child: _selectedSegmentValue == 0
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
