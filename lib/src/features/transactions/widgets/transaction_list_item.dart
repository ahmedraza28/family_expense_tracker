import 'package:flutter/material.dart';

// Models
import '../models/transaction_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel? transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    required this.onTap,
    super.key,
    this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        dense: true,
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal:15,
          vertical: 5,
        ),
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded15,
        ),
        leading: const Icon(
          Icons.category_rounded,
          color: AppColors.textLightGreyColor,
        ),
        trailing: InkWell(
          onTap: () {
            AppRouter.pushNamed(Routes.AddEditCategoryScreenRoute);
          },
          child: const Icon(
            Icons.edit_rounded,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),
        title: CustomText.body(
          'Category Name',
        ),
      ),
    );
  }
}
