import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/category_model.codegen.dart';

// Providers
import '../providers/selected_categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class MultiCategoryField extends ConsumerWidget {
  const MultiCategoryField({
    required this.categoriesController,
    super.key,
  });

  final ValueNotifier<List<CategoryModel>> categoriesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
        borderRadius: Corners.rounded7,
      ),
      onTap: () async {
        ref
            .read(selectedCategoriesProvider.notifier)
            .addAll(categoriesController.value);
        final categories = await AppRouter.pushNamed(
          Routes.SelectCategoriesScreenRoute,
        ) as List<CategoryModel>;
        categoriesController.value = categories;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          color: AppColors.fieldFillColor,
          borderRadius: Corners.rounded7,
        ),
        child: ValueListenableBuilder(
          valueListenable: categoriesController,
          builder: (context, categories, _) {
            return CustomChipsList(
              chipLabels: [for (final category in categories) category.name],
              isScrollable: true,
              backgroundColor: AppColors.surfaceColor,
              borderColor: Colors.transparent,
              labelColor: const Color.fromARGB(255, 160, 169, 173),
              chipHeight: 30,
              chipGap: 10,
            );
          },
        ),
      ),
    );
  }
}
