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

// Features
import '../../shared/shared.dart';

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
    final isEnabledController = useValueNotifier<bool>(
      category?.isEnabled ?? true,
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (category == null) {
        ref.read(categoriesProvider.notifier).addCategory(
              name: categoryNameController.text,
              color: colorController.value,
              isEnabled: isEnabledController.value,
            );
      } else {
        final newCategory = category!.copyWith(
          name: categoryNameController.text,
          color: colorController.value,
          isEnabled: isEnabledController.value,
        );
        ref.read(categoriesProvider.notifier).updateCategory(newCategory);
      }
      (onPressed ?? AppRouter.pop).call();
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          category == null ? 'Add a new category' : 'Edit category',
          fontSize: 20,
        ),
        actions: [
          // Enable Button
          if (category != null)
            EnableDisableSwitch(
              controller: isEnabledController,
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

              // Wallet Color And Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Category Name
                  Expanded(
                    child: CustomTextField(
                      controller: categoryNameController,
                      floatingText: 'Category Name',
                      hintText: 'Enter category name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: FormValidator.nameValidator,
                    ),
                  ),

                  Insets.gapW10,

                  // Category Color
                  Padding(
                    padding: const EdgeInsets.only(top: 23),
                    child: ColorPickerButton(
                      controller: colorController,
                      iconData: Icons.category_rounded,
                    ),
                  )
                ],
              ),

              Insets.gapH(110),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingSaveButton(onSave: onSave),
    );
  }
}
