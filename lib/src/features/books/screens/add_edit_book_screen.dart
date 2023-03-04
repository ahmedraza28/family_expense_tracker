import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/form_validator.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddEditBookScreen extends HookConsumerWidget {
  const AddEditBookScreen({super.key});

  // void saveForm(
  //   WidgetRef ref, {
  //   required int gradYear,
  //   required CurrencyModel currencyId,
  //   required CampusModel campusId,
  // }) {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     ref.read(registerFormProvider.notifier).saveUniversityDetails(
  //           gradYear: gradYear,
  //           programId: programId,
  //           campusId: campusId,
  //         );
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final savedFormData = ref.watch(
    //   registerFormProvider.notifier
    //       .select((value) => value.savedUniversityDetails),
    // );
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final currencyController = useValueNotifier<String>('');
    final bookNameController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Add a new book',
          fontSize: 20,
        ),
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
                'Create a book in which you will record income and expenses',
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),

              Insets.gapH20,

              // Book Name
              CustomTextField(
                controller: bookNameController,
                floatingText: 'Book Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
              ),

              Insets.gapH20,

              // Currency Dropdown
              LabeledWidget(
                label: 'Currency',
                useDarkerLabel: true,
                child: CustomDropdownField<String>.animated(
                  controller: currencyController,
                  hintText: 'Pick a currency',
                  items: {
                    for (var e in <String>['AED', 'PKR', 'USD']) e: e
                  },
                ),
              ),

              Insets.expand,

              // Confirm Details Button
              CustomTextButton.gradient(
                width: double.infinity,
                onPressed: () {
                  // saveForm(
                  //   ref,
                  //   gradYear: gradYearController.value!,
                  //   programId: programIdController.value!,
                  //   campusId: campusIdController.value!,
                  // );
                },
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
