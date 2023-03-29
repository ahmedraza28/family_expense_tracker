import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/form_validator.dart';

// Routing
import '../../../config/routing/routing.dart';

// Models
import '../models/category_model.codegen.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddEditCategoryScreen extends HookConsumerWidget {
  final CategoryModel? category;
  final VoidCallback? onPressed;

  const AddEditCategoryScreen({
    super.key,
    this.category,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final categoryNameController = useTextEditingController(
      text: category?.name ?? '',
    );
    final colorController = useValueNotifier<Color>(
      category?.color ?? AppColors.primaryColor,
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (category == null) {
        ref.read(categoriesProvider.notifier).addCategory(
              name: categoryNameController.text,
              color: colorController.value,
              imageUrl: '',
            );
      } else {
        final newCategory = category!.copyWith(
          name: categoryNameController.text,
          color: colorController.value,
          imageUrl: '',
        );
        ref.read(categoriesProvider.notifier).updateCategory(
              newCategory,
            );
      }
      (onPressed ?? AppRouter.pop).call();
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
              ),

              Insets.gapH20,

              // Category Name
              CustomTextField(
                controller: categoryNameController,
                floatingText: 'Category Name',
                hintText: 'Enter category name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
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
