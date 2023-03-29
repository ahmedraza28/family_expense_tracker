import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/selected_categories_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Providers

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/selectable/selectable_categories_list.dart';

class SelectCategoriesScreen extends ConsumerWidget {
  const SelectCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Categories',
          fontSize: 20,
        ),
        actions: [
          // Done button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 13, 8, 13),
            child: CustomTextButton(
              width: 60,
              onPressed: () {
                final categories = ref.read(selectedCategoriesProvider);
                AppRouter.pop(categories);
              },
              child: Center(
                child: CustomText.subtitle(
                  'Done',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const SelectableCategoriesList(),
    );
  }
}
