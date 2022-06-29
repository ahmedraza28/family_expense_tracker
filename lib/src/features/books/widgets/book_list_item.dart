import 'package:flutter/material.dart';

// Models
import '../models/book_model.codegen.dart';

// Helpers
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';
import '../../../helpers/constants/app_typography.dart';

// Widgets
import '../../shared/widgets/custom_text_button.dart';

class BookListItem extends StatelessWidget {
  final BookModel? book;
  final VoidCallback onTap;

  const BookListItem({
    super.key,
    this.book,
    required this.onTap,
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
            // Title and Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Timetable Number
                Text(
                  'Book Name',
                  style: AppTypography.primary.title18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 25,
                )
              ],
            ),

            Insets.gapH15,

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
              ),
            ),

            Insets.gapH5,

            // Creator
            const Text(
              'Created By',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLightGreyColor,
              ),
            ),

            Insets.expand,

            // Set Active Button
            CustomTextButton.gradient(
              height: 35,
              width: 100,
              onPressed: () {},
              gradient: AppColors.buttonGradientPurple,
              child: Center(
                child: Text(
                  'Add Members',
                  style: AppTypography.secondary.subtitle13.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
