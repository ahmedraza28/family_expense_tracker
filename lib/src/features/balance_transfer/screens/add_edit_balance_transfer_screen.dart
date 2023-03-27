import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/balance_transfer_provider.codegen.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../calculator/calculator.dart';
import '../../wallets/wallets.dart';

class AddEditBalanceTransferScreen extends HookConsumerWidget {
  final BalanceTransferModel? balanceTransfer;
  final VoidCallback? onPressed;

  const AddEditBalanceTransferScreen({
    super.key,
    this.balanceTransfer,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final amountController = useTextEditingController(
      text: balanceTransfer?.amount.toString() ?? '',
    );
    final descriptionController = useTextEditingController(
      text: balanceTransfer?.description ?? '',
    );
    final dateController = useValueNotifier<DateTime?>(
      balanceTransfer?.date,
    );
    final srcWalletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(balanceTransfer?.srcWalletId)),
    );
    final srcWalletTextController = useTextEditingController(
      text: srcWalletController.value?.name ?? '',
    );
    final destWalletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(balanceTransfer?.destWalletId)),
    );
    final destWalletTextController = useTextEditingController(
      text: destWalletController.value?.name ?? '',
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (balanceTransfer == null) {
        ref.read(balanceTransferProvider.notifier).addTransaction(
              amount: double.parse(amountController.text),
              srcWalletId: srcWalletController.value!.id!,
              date: dateController.value!,
              destWalletId: destWalletController.value!.id!,
              description: descriptionController.text,
            );
      } else {
        final newTransfer = balanceTransfer!.copyWith(
          amount: double.parse(amountController.text),
          srcWalletId: srcWalletController.value!.id!,
          date: dateController.value!,
          destWalletId: destWalletController.value!.id!,
          description: descriptionController.text,
        );
        ref
            .read(balanceTransferProvider.notifier)
            .updateTransaction(newTransfer);
      }
      (onPressed ?? AppRouter.pop).call();
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          balanceTransfer == null ? 'Add a new transfer' : 'Edit transfer',
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
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: () async {
                  await AppRouter.pushNamed(
                    Routes.CalculatorScreenRoute,
                  );
                  amountController.text = ref.read(numberResultProvider);
                },
                child: CustomTextField(
                  controller: amountController,
                  enabled: false,
                  hintText: 'Tap to calculate',
                  floatingText: 'Amount',
                ),
              ),

              Insets.gapH20,

              // Source Wallet
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: () async {
                  ref
                      .read(isWalletSelectableProvider.notifier)
                      .update((_) => true);
                  final wallet = await AppRouter.pushNamed(
                    Routes.WalletsScreenRoute,
                  ) as WalletModel;
                  srcWalletController.value = wallet;
                  srcWalletTextController.text = wallet.name;
                },
                child: CustomTextField(
                  controller: srcWalletTextController,
                  enabled: false,
                  hintText: 'Transfer from',
                  floatingText: 'Source Wallet',
                ),
              ),

              Insets.gapH20,

              // Destination Wallet
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: () async {
                  ref
                      .read(isWalletSelectableProvider.notifier)
                      .update((_) => true);
                  final wallet = await AppRouter.pushNamed(
                    Routes.WalletsScreenRoute,
                  ) as WalletModel;
                  destWalletController.value = wallet;
                  destWalletTextController.text = wallet.name;
                },
                child: CustomTextField(
                  controller: destWalletTextController,
                  enabled: false,
                  hintText: 'Transfer to',
                  floatingText: 'Destination Wallet',
                ),
              ),

              Insets.gapH20,

              // Transfer date
              CustomDatePicker(
                firstDate: DateTime(2023),
                dateNotifier: dateController,
                dateFormat: DateFormat('d MMMM, y'),
                helpText: 'Select Date',
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                pickerStyle: const CustomDatePickerStyle(
                  initialDateString: 'dd month, yyyy',
                  floatingText: 'Date',
                ),
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
