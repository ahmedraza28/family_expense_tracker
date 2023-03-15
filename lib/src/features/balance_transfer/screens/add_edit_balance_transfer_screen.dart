import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Features
import '../../calculator/calculator.dart';
import '../../wallets/wallets.dart';

class AddEditBalanceTransferScreen extends HookConsumerWidget {
  final BalanceTransferModel? balanceTransfer;

  const AddEditBalanceTransferScreen({
    super.key,
    this.balanceTransfer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final amountController = useTextEditingController(
      text: balanceTransfer?.amount.toString() ?? '',
    );
    final noteController = useTextEditingController(
      text: balanceTransfer?.note ?? '',
    );
    final dateController = useValueNotifier<DateTime?>(
      balanceTransfer?.date,
    );
    final srcWalletController = useValueNotifier<WalletModel?>(
      balanceTransfer?.srcWallet,
    );
    final destWalletController = useValueNotifier<WalletModel?>(
      balanceTransfer?.destWallet,
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (balanceTransfer == null) {
        // ref.read(balanceTransferProvider).create(
        //       amount: double.parse(amountController.text),
        //       srcWallet: srcWalletController.value!,
        //       date: dateController.value!,
        //       destWallet: destWalletController.value!,
        //       note: noteController.text,
        //     );
      } else {
        final newTransfer = balanceTransfer!.copyWith(
          amount: double.parse(amountController.text),
          srcWallet: srcWalletController.value!,
          date: dateController.value!,
          destWallet: destWalletController.value!,
          note: noteController.text,
        );
        // ref.read(balanceTransferProvider).updateBalanceTransfer(newTransfer);
      }
      AppRouter.pop();
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
                'Create a balance transfer to another wallet',
                fontSize: 16,
                maxLines: 2,
              ),

              Insets.gapH20,

              // Amount
              GestureDetector(
                onTap: () async {
                  await AppRouter.pushNamed(
                    Routes.CalculatorScreenRoute,
                  );
                  amountController.text = ref.read(numberResultProvider);
                },
                child: CustomTextField(
                  controller: amountController,
                  enabled: false,
                  floatingText: 'Amount',
                ),
              ),

              Insets.gapH20,

              // Source Wallet
              Consumer(
                builder: (_, ref, __) {
                  final walletsStream = ref.watch(walletsStreamProvider);
                  return LabeledWidget(
                    label: 'Source Wallet',
                    child: CustomDropdownField<WalletModel>.sheet(
                      controller: srcWalletController,
                      selectedItemBuilder: (item) => CustomText.body(item.name),
                      hintText: 'Transfer from',
                      itemsSheet: CustomDropdownSheet(
                        items: walletsStream.valueOrNull ?? [],
                        bottomSheetTitle: 'Wallets',
                        itemBuilder: (_, item) => DropdownSheetItem(
                          label: item.name,
                        ),
                      ),
                    ),
                  );
                },
              ),

              Insets.gapH20,

              // Destination Wallet
              Consumer(
                builder: (_, ref, __) {
                  final walletsStream = ref.watch(walletsStreamProvider);
                  return LabeledWidget(
                    label: 'Destination Wallet',
                    child: CustomDropdownField<WalletModel>.sheet(
                      controller: destWalletController,
                      selectedItemBuilder: (item) => CustomText.body(item.name),
                      hintText: 'Transfer to',
                      itemsSheet: CustomDropdownSheet(
                        items: walletsStream.valueOrNull ?? [],
                        bottomSheetTitle: 'Wallets',
                        itemBuilder: (_, item) => DropdownSheetItem(
                          label: item.name,
                        ),
                      ),
                    ),
                  );
                },
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
