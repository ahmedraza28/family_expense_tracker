import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/book_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_book_screen.dart';

// Features
import '../../wallets/wallets.dart';

class BookListItem extends ConsumerWidget {
  final BookModel book;

  const BookListItem({
    required this.book,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectedBookProvider, (prev, next) {
      if (next != null && next.id == book.id) {
        AppRouter.pushNamed(Routes.BookConfigLoaderScreenRoute);
      }
    });
    return InkWell(
      onTap: () {
        ref.read(selectedBookProvider.notifier).update((state) => book);
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
          boxShadow: Shadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Edit
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
              child: Row(
                children: [
                  // Book Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: book.color.withOpacity(0.2),
                      borderRadius: Corners.rounded9,
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      color: book.color,
                    ),
                  ),

                  Insets.gapW15,

                  // Book Name
                  CustomText.body(
                    book.name,
                    fontSize: 20,
                  ),

                  Insets.expand,

                  // Edit button
                  CustomTextButton.gradient(
                    height: 30,
                    width: 55,
                    onPressed: () => AppRouter.push(
                      AddEditBookScreen(book: book),
                    ),
                    gradient: AppColors.buttonGradientPrimary,
                    child: Center(
                      child: CustomText.subtitle(
                        'Edit',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.black, height: 0),

            // Details
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Amount
                  LabeledWidget(
                    label: 'Balance',
                    labelStyle: const TextStyle(
                      color: AppColors.textBlueGreyColor,
                    ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final currency = ref.watch(
                          currencyByNameProvider(book.currencyName),
                        );
                        return CustomText.body(
                          '${currency.symbol} ${book.totalIncome - book.totalExpense}',
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ),

                  Insets.gapH10,

                  // Members Row
                  LabeledWidget(
                    label: 'Members',
                    labelStyle: const TextStyle(
                      color: AppColors.textBlueGreyColor,
                    ),
                    child: SizedBox(
                      height: 36,
                      child: Row(
                        children: [
                          // Members Avatars
                          SizedBox(
                            width: 80,
                            child: Stack(
                              children: [
                                // Avatar 1
                                Positioned(
                                  left: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaries[0],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                // Avatar 2
                                Positioned(
                                  left: 20,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaries[1],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                // Avatar 3
                                Positioned(
                                  left: 40,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaries[2],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Insets.gapW5,

                          // Edit users
                          InkWell(
                            onTap: () {
                              AppRouter.pushNamed(
                                Routes.ManageBookAccessScreenRoute,
                              );
                            },
                            child: const CustomText(
                              'Manage Access',
                              fontSize: 13,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
