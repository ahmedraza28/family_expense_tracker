import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Providers
import '../providers/transactions_provider.codegen.dart';

// Features
import '../../calculator/calculator.dart';
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';

class AddEditTransactionScreen extends HookConsumerWidget {
  final IncomeExpenseModel? transaction;

  const AddEditTransactionScreen({
    super.key,
    this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final amountController = useTextEditingController(
      text: transaction?.amount.toString() ?? '',
    );
    final descriptionController = useTextEditingController(
      text: transaction?.description ?? '',
    );
    final dateController = useValueNotifier<DateTime?>(
      transaction?.date,
    );
    final walletController = useValueNotifier<WalletModel?>(
      transaction?.wallet,
    );
    final categoryController = useValueNotifier<CategoryModel?>(
      ref.watch(categoryByIdProvider(transaction?.categoryId)),
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (transaction == null) {
        ref.read(transactionsProvider).addTransaction(
              amount: double.parse(amountController.text),
              wallet: walletController.value!,
              date: dateController.value!,
              category: categoryController.value!,
              description: descriptionController.text,
            );
      } else {
        final newTransaction = transaction!.copyWith(
          amount: double.parse(amountController.text),
          wallet: walletController.value!,
          date: dateController.value!,
          categoryId: categoryController.value!.id!,
          description: descriptionController.text,
        );
        ref.read(transactionsProvider).updateTransaction(newTransaction);
      }
      AppRouter.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          transaction != null ? 'Edit transaction' : 'Add a new transaction',
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
                'Add details about a transaction',
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

              // Category
              LabeledWidget(
                label: 'Category',
                child: CategoryDropdownField(
                  controller: categoryController,
                ),
              ),

              Insets.gapH20,

              // Wallet
              Consumer(
                builder: (_, ref, __) {
                  final walletsStream = ref.watch(walletsStreamProvider);
                  return LabeledWidget(
                    label: 'Wallet',
                    child: CustomDropdownField<WalletModel>.sheet(
                      controller: walletController,
                      selectedItemBuilder: (item) => CustomText.body(item.name),
                      hintText: 'Spend from',
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
                controller: descriptionController,
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
