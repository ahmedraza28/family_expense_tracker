import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Providers

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class TransferBalanceScreen extends HookConsumerWidget {
  const TransferBalanceScreen({super.key});

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
    final amountController = useTextEditingController(
        // text: savedFormData?.amount ?? '',
        );
    final noteController = useTextEditingController(
        // text: savedFormData?.amount ?? '',
        );
    final dateController = useValueNotifier<DateTime?>(
      null,
      // savedFormData?.birthday,
    );
    final srcWalletController = useValueNotifier<WalletModel?>(
      null,
      // savedFormData?.srcWallet,
    );
    final destWalletController = useValueNotifier<WalletModel?>(
      null,
      // savedFormData?.destWallet,
    );

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
                'Create a balance transfer to another wallet',
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
              ),

              Insets.gapH20,

              // Amount
              GestureDetector(
                onTap: () async {
                  final amount = await AppRouter.pushNamed(
                    Routes.CalculatorScreenRoute,
                  ) as double;
                  amountController.text = amount.toString();
                },
                child: CustomTextField(
                  controller: amountController,
                  enabled: false,
                  floatingText: 'Amount',
                ),
              ),

              Insets.gapH20,

              // Source Wallet
              LabeledWidget(
                label: 'Source Wallet',
                child: CustomDropdownField<WalletModel>.sheet(
                  controller: srcWalletController,
                  selectedItemBuilder: (item) => CustomText.body(item.name),
                  hintText: 'Transfer from',
                  itemsSheet: CustomDropdownSheet(
                    items: const [
                      WalletModel(
                        id: 1,
                        name: 'Wallet 1',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 1000,
                      ),
                      WalletModel(
                        id: 2,
                        name: 'Wallet 2',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 2000,
                      ),
                      WalletModel(
                        id: 3,
                        name: 'Wallet 3',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 3000,
                      ),
                    ],
                    bottomSheetTitle: 'Wallets',
                    itemBuilder: (_, item) => DropdownSheetItem(
                      label: item.name,
                    ),
                  ),
                ),
              ),

              Insets.gapH20,

              // Destination Wallet
              LabeledWidget(
                label: 'Destination Wallet',
                child: CustomDropdownField<WalletModel>.sheet(
                  controller: destWalletController,
                  selectedItemBuilder: (item) => CustomText.body(item.name),
                  hintText: 'Transfer to',
                  itemsSheet: CustomDropdownSheet(
                    items: const [
                      WalletModel(
                        id: 1,
                        name: 'Wallet 1',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 1000,
                      ),
                      WalletModel(
                        id: 2,
                        name: 'Wallet 2',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 2000,
                      ),
                      WalletModel(
                        id: 3,
                        name: 'Wallet 3',
                        imageUrl: 'https://picsum.photos/200',
                        balance: 3000,
                      ),
                    ],
                    bottomSheetTitle: 'Wallets',
                    itemBuilder: (_, item) => DropdownSheetItem(
                      label: item.name,
                    ),
                  ),
                ),
              ),

              Insets.gapH20,

              // Transfer date
              CustomDatePicker(
                firstDate: DateTime(1950),
                dateNotifier: dateController,
                dateFormat: DateFormat('d MMMM, y'),
                helpText: 'Select Date',
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                pickerStyle: const CustomDatePickerStyle(
                  initialDateString: 'DD MONTH, YYYY',
                  floatingText: 'Date',
                ),
              ),

              Insets.gapH20,

              // Note
              CustomTextField(
                controller: noteController,
                floatingText: 'Note',
                keyboardType: TextInputType.text,
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
