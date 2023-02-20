import 'package:flutter/material.dart';

// Models
import '../models/book_model.codegen.dart';

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
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
          boxShadow: Shadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Book Name
                CustomText.title(
                  'Book Name',
                ),

                // Edit pencil
                const Icon(
                  Icons.edit,
                  size: 25,
                )
              ],
            ),

            Insets.gapH15,

            // Balance
            const CustomText(
              'Balance',
              fontSize: 16,
            ),

            Insets.gapH5,

            // Balance Amount
            CustomText.body(
              'Rs100,000',
              fontWeight: FontWeight.bold,
            ),

            Insets.expand,

            // Members Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Members Avatars
                Stack(
                  children: const [

                    // Avatar 1
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Avatar 2
                    Positioned(
                      left: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Avatar 3
                    Positioned(
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                CustomTextButton.gradient(
                  height: 35,
                  width: 100,
                  onPressed: () {},
                  gradient: AppColors.buttonGradientPrimary,
                  child: Center(
                    child: CustomText.subtitle(
                      'Manage',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            Insets.gapH15,

            // View Book
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.adaptive.arrow_forward_rounded,
                color: AppColors.primaryColor,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
