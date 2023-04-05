import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/selected_budgets_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/selectable/selectable_budgets_view.dart';

class SelectBudgetsScreen extends ConsumerWidget {
  const SelectBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Budgets',
          fontSize: 20,
        ),
        actions: [
          // Done button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 13, 8, 13),
            child: CustomTextButton(
              width: 60,
              onPressed: () {
                final budgets = ref.read(selectedBudgetsProvider);
                AppRouter.pop(budgets);
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
      body: const SelectableBudgetsView(),
    );
  }
}
