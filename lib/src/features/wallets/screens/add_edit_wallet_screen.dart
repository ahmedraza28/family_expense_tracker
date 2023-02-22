import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/form_validator.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddEditWalletScreen extends HookConsumerWidget {
  const AddEditWalletScreen({super.key});

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
    final walletNameController = useTextEditingController(
        // text: savedFormData?.walletName ?? '',
        );
    final walletBalanceController = useTextEditingController(
        // text: savedFormData?.walletBalance ?? '',
        );

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Add a new wallet',
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
                'Create a wallet for storing your balance',
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),

              Insets.gapH20,

              // Wallet Name
              CustomTextField(
                controller: walletNameController,
                floatingText: 'Wallet Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
              ),

              Insets.gapH20,

              // Wallet Balance
              CustomTextField(
                controller: walletBalanceController,
                floatingText: 'Balance',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
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
