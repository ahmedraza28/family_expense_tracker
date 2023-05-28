import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/object_extensions.dart';
import '../../../helpers/form_validator.dart';

// Providers
import '../../transactions/transactions.dart';
import '../providers/balance_transfer_provider.codegen.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Widgets
import '../../shared/widgets/floating_save_button.dart';
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
      text: balanceTransfer?.amount.toString() ?? '0',
    );
    final descriptionController = useTextEditingController(
      text: balanceTransfer?.description,
    );
    final dateController = useValueNotifier<DateTime>(
      balanceTransfer?.date ??
          ref.watch(selectedDateProvider) ??
          DateTime.now(),
    );
    final srcWalletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(balanceTransfer?.srcWalletId)),
    );
    final destWalletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(balanceTransfer?.destWalletId)),
    );

    void onSave() {
      if (!formKey.currentState!.validate() ||
          destWalletController.value.isNull ||
          srcWalletController.value.isNull ||
          dateController.value.isNull) {
        return;
      }
      formKey.currentState!.save();
      if (balanceTransfer == null) {
        final nowDate = DateTime.now();
        final date = dateController.value.copyWith(
          hour: nowDate.hour,
          minute: nowDate.minute,
          second: nowDate.second,
        );
        ref.read(balanceTransferProvider.notifier).addTransaction(
              amount: double.parse(amountController.text),
              srcWalletId: srcWalletController.value!.id,
              date: date,
              destWalletId: destWalletController.value!.id,
              description: descriptionController.text,
            );
      } else {
        final newTransfer = balanceTransfer!.copyWith(
          amount: double.parse(amountController.text),
          srcWalletId: srcWalletController.value!.id,
          date: dateController.value,
          destWalletId: destWalletController.value!.id,
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
          if (balanceTransfer != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(balanceTransferProvider.notifier)
                    .deleteTransaction(balanceTransfer!);
                AppRouter.pop();
              },
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
                  if (balanceTransfer != null) {
                    ref
                        .read(numberInputProvider.notifier)
                        .replace(amountController.text);
                  }
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
                  validator: FormValidator.nonEmptyValidator,
                ),
              ),

              Insets.gapH20,

              // Source Wallet
              LabeledWidget(
                label: 'Source Wallet',
                useDarkerLabel: true,
                child: WalletDropdownField(
                  controller: srcWalletController,
                ),
              ),

              Insets.gapH20,

              // Destination Wallet
              LabeledWidget(
                label: 'Destination Wallet',
                useDarkerLabel: true,
                child: WalletDropdownField(
                  controller: destWalletController,
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

              Insets.gapH(114),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingSaveButton(onSave: onSave),
    );
  }
}
