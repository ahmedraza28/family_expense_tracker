import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Providers
import '../../calculator/calculator.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';
import '../models/wallet_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddEditBalanceTransferScreen extends HookConsumerWidget {
  final BalanceTransferModel? balanceTransfer;

  const AddEditBalanceTransferScreen({
    super.key,
    this.balanceTransfer,
  });

  void save(
    WidgetRef ref, {
    required double amount,
    required WalletModel srcWallet,
    required DateTime date,
    required WalletModel destWallet,
    String? note,
  }) {
    if (balanceTransfer == null) {
      // ref.read(balanceTransferProvider.notifier).create(
      //   amount: amount,
      //   srcWallet: srcWallet,
      //   date: date,
      //   destWallet: destWallet,
      //   note: note,
      // );
    } else {
      // ref.read(balanceTransferProvider.notifier).edit(
      //   amount: amount,
      //   srcWallet: srcWallet,
      //   date: date,
      //   destWallet: destWallet,
      //   note: note,
      // );
    }
  }

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
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    save(
                      ref,
                      amount: double.parse(amountController.text),
                      srcWallet: srcWalletController.value!,
                      date: dateController.value!,
                      destWallet: destWalletController.value!,
                      note: noteController.text,
                    );
                  }
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
