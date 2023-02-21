import 'package:flutter/material.dart';

// Models
import '../models/book_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class BookListItem extends StatelessWidget {
  final BookModel? book;
  final VoidCallback onTap;

  const BookListItem({
    required this.onTap,
    super.key,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Book Name
                  CustomText.title(
                    'Book Name',
                    fontSize: 20,
                  ),

                  // Edit button
                  CustomTextButton.gradient(
                    height: 30,
                    width: 55,
                    onPressed: () {
                      AppRouter.pushNamed(
                        Routes.AddEditBookScreenRoute,
                      );
                    },
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
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Amount
                  LabeledWidget(
                    label: 'Balance',
                    child: CustomText.body(
                      'Rs100,000',
                    ),
                  ),

                  Insets.gapH10,

                  // Members Row
                  LabeledWidget(
                    label: 'Members',
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
