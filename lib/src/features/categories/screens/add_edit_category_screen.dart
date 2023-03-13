import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/form_validator.dart';

// Enums
import '../enums/category_type_enum.dart';

// Models
import '../models/category_model.codegen.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/category_type_selection_cards.dart';

class AddEditCategoryScreen extends HookConsumerWidget {
  final CategoryModel? category;

  const AddEditCategoryScreen({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final categoryNameController = useTextEditingController(
      text: category?.name ?? '',
    );
    final typeController = useValueNotifier<CategoryType>(
      category?.type ?? CategoryType.income,
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (category == null) {
        ref.read(categoriesProvider).addCategory(
              name: categoryNameController.text,
              type: typeController.value,
              imageUrl: '',
            );
      } else {
        final newCategory = category!.copyWith(
          name: categoryNameController.text,
          type: typeController.value,
          imageUrl: '',
        );
        ref.read(categoriesProvider).updateCategory(newCategory);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Add a new category',
          fontSize: 20,
        ),
        actions: [
          // Delete Button
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: ScrollableColumn(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Insets.gapH20,

              const CustomText(
                'Create a category for organizing your transactions',
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),

              Insets.gapH20,

              // Category Name
              CustomTextField(
                controller: categoryNameController,
                floatingText: 'Category Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
              ),

              Insets.gapH20,

              // Category Type
              LabeledWidget(
                label: 'Category Type',
                useDarkerLabel: true,
                child: CategoryTypeSelectionCards(
                  controller: typeController,
                ),
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
