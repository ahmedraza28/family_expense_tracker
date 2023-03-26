import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/budgets_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../global/formatters/formatters.dart';
import '../../../helpers/constants/constants.dart';

// Models
import '../models/budget_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../transactions/transactions.dart';
import '../../categories/categories.dart';

class AddEditBudgetScreen extends HookConsumerWidget {
  final BudgetModel? budget;
  final VoidCallback? onPressed;

  const AddEditBudgetScreen({
    super.key,
    this.budget,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final categoryController = useValueNotifier<CategoryModel?>(
      ref.watch(categoryByIdProvider(budget?.categoryId)),
    );
    final categoryTextController = useTextEditingController(
      text: categoryController.value?.name ?? '',
    );
    final budgetAmountController = useTextEditingController(
      text: budget?.amount.toString() ?? '',
    );
    final descriptionController = useTextEditingController(
      text: budget?.description ?? '',
    );
    final monthFilterController = useValueNotifier<int?>(null);
    final yearFilterController = useValueNotifier<int?>(null);

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (budget == null) {
        ref.read(budgetsProvider.notifier).addBudget(
              year: yearFilterController.value!,
              month: monthFilterController.value!,
              categoryId: categoryController.value!.id!,
              amount: double.parse(budgetAmountController.text),
              description: descriptionController.text,
            );
      } else {
        final newBudget = budget!.copyWith(
          year: yearFilterController.value!,
          month: monthFilterController.value!,
          categoryId: categoryController.value!.id!,
          amount: double.parse(budgetAmountController.text),
          description: descriptionController.text,
        );
        ref.read(budgetsProvider.notifier).updateBudget(newBudget);
      }
      (onPressed ?? AppRouter.pop).call();
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          budget != null ? 'Edit a budget' : 'Add a new budget',
          fontSize: 20,
        ),
        actions: [
          // Delete Button
          if (budget != null)
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Form(
          key: formKey,
          child: ScrollableColumn(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Insets.gapH20,

              const CustomText(
                'Create a budget for storing your balance',
                fontSize: 16,
                maxLines: 2,
              ),

              Insets.gapH20,

              // Category
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: () async {
                  ref
                      .read(isCategorySelectableProvider.notifier)
                      .update((_) => true);
                  final category = await AppRouter.pushNamed(
                    Routes.CategoriesScreenRoute,
                  ) as CategoryModel;
                  categoryController.value = category;
                  categoryTextController.text = category.name;
                },
                child: CustomTextField(
                  controller: categoryTextController,
                  enabled: false,
                  hintText: 'Tap to select',
                  floatingText: 'Category',
                ),
              ),

              Insets.gapH20,

              // Budget Balance
              CustomTextField(
                controller: budgetAmountController,
                floatingText: 'Balance',
                hintText: '0.0',
                inputFormatters: [
                  DecimalTextInputFormatter(decimalDigits: 1),
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
              ),

              Insets.gapH20,

              // Period
              Row(
                children: [
                  // Month Dropdown Filter
                  Expanded(
                    child: LabeledWidget(
                      label: 'Month',
                      useDarkerLabel: true,
                      child: CustomDropdownField<int>.animated(
                        controller: monthFilterController,
                        hintText: 'Select',
                        items: monthNames,
                      ),
                    ),
                  ),

                  Insets.gapW15,

                  // Year Dropdown Filter
                  Expanded(
                    child: LabeledWidget(
                      label: 'Year',
                      useDarkerLabel: true,
                      child: CustomDropdownField<int>.animated(
                        controller: yearFilterController,
                        hintText: 'Select',
                        items: {
                          for (var i = 2023;
                              i <= (DateTime.now().year + 10);
                              i++)
                            i.toString(): i
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Insets.gapH20,

              // Description
              CustomTextField(
                controller: descriptionController,
                floatingText: 'Description (Optional)',
                hintText: 'Type here...',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              Insets.expand,

              // Confirm Details Button
              CustomTextButton.gradient(
                width: double.infinity,
                onPressed: onSave,
                gradient: AppColors.buttonGradientPrimary,
                child: const Center(
                  child: CustomText(
                    'Save',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),

              Insets.bottomInsetsLow,
            ],
          ),
        ),
      ),
    );
  }
}
