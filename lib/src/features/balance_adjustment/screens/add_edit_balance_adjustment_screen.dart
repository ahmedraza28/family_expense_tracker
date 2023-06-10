import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/object_extensions.dart';

// Providers
import '../../transactions/transactions.dart';
import '../providers/balance_adjustment_provider.codegen.dart';

// Models
import '../models/balance_adjustment_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../../shared/widgets/floating_save_button.dart';

// Features
import '../../calculator/calculator.dart';
import '../../wallets/wallets.dart';

class AddEditBalanceAdjustmentScreen extends HookConsumerWidget {
  final BalanceAdjustmentModel? balanceAdjustment;
  final WalletModel? wallet;

  const AddEditBalanceAdjustmentScreen({
    super.key,
    this.balanceAdjustment,
    this.wallet,
  }) : assert(
          balanceAdjustment != null || wallet != null,
          'Either balanceAdjustment or wallet must be provided',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final amountController = useTextEditingController(
      text: balanceAdjustment?.amount.toString() ?? wallet?.balance.toString() ?? '0',
    );
    final dateController = useValueNotifier<DateTime>(
      balanceAdjustment?.date ??
          ref.watch(selectedDateProvider) ??
          DateTime.now(),
    );
    final walletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(balanceAdjustment?.walletId)) ?? wallet,
    );
    final previousBalance = useMemoized(
      () => (balanceAdjustment?.previousAmount ?? wallet?.balance ?? 0.0).toString(),
    );

    void onSave() {
      if (!formKey.currentState!.validate() ||
          dateController.value.isNull ||
          walletController.value.isNull) {
        return;
      }
      formKey.currentState!.save();
      final nowDate = DateTime.now();
      final date = dateController.value.copyWith(
        hour: nowDate.hour,
        minute: nowDate.minute,
        second: nowDate.second,
      );
      ref.read(balanceAdjustmentProvider.notifier).addTransaction(
            amount: double.parse(amountController.text),
            prevAmount: walletController.value!.balance,
            walletId: walletController.value!.id,
            date: date,
          );
      AppRouter.pop(double.parse(amountController.text));
    }

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Add a new adjustment',
          fontSize: 20,
        ),
        actions: [
          // Delete Button
          if (balanceAdjustment != null)
            IconButton(
              onPressed: () {
                ref
                    .read(balanceAdjustmentProvider.notifier)
                    .deleteTransaction(balanceAdjustment!);
                AppRouter.pop();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ScrollableColumn(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Insets.gapH20,

            const CustomText(
              'Create a balance adjustment to manually adjust the balance of a wallet.',
              fontSize: 16,
              maxLines: 2,
            ),

            Insets.gapH20,

            // Previous Amount
            CustomTextField(
              enabled: false,
              initialValue: previousBalance,
              floatingText: 'Previous Amount',
            ),

            Insets.gapH20,

            // Amount
            InkWell(
              customBorder: const RoundedRectangleBorder(
                borderRadius: Corners.rounded7,
              ),
              onTap: () async {
                ref
                    .read(numberInputProvider.notifier)
                    .replace(amountController.text);
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

            // Wallet
            LabeledWidget(
              label: 'Wallet',
              useDarkerLabel: true,
              child: WalletDropdownField(
                controller: walletController,
              ),
            ),

            Insets.gapH20,

            // Adjustment date
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

            Insets.gapH(110),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          balanceAdjustment == null ? FloatingSaveButton(onSave: onSave) : null,
    );
  }
}
