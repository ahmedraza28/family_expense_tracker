import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Routing
import '../../../config/routing/routing.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Helpers
import '../enums/transaction_type_enum.dart';
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/add_edit_transaction_provider.codegen.dart';
import '../providers/income_expense_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/transaction_type_selection_cards.dart';

// Features
import '../../calculator/calculator.dart';
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';

class AddEditTransactionScreen extends HookConsumerWidget {
  final IncomeExpenseModel? transaction;
  final VoidCallback? onPressed;

  const AddEditTransactionScreen({
    super.key,
    this.transaction,
    this.onPressed,
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
    final dateController = useValueNotifier<DateTime>(
      transaction?.date ?? ref.watch(selectedDateProvider) ?? DateTime.now(),
    );

    final walletId =
        transaction?.walletId ?? ref.watch(selectedWalletIdProvider);
    final walletController = useValueNotifier<WalletModel?>(
      ref.watch(walletByIdProvider(walletId)),
    );

    final categoryId =
        transaction?.categoryId ?? ref.watch(selectedCategoryIdProvider);
    final categoryController = useValueNotifier<CategoryModel?>(
      ref.watch(categoryByIdProvider(categoryId)),
    );
    final typeController = useValueNotifier<TransactionType?>(
      transaction?.type ?? TransactionType.expense,
    );

    void onSave() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (transaction == null) {
        ref.read(incomeExpenseProvider.notifier).addTransaction(
              amount: double.parse(amountController.text),
              walletId: walletController.value!.id!,
              date: dateController.value,
              type: typeController.value!,
              categoryId: categoryController.value!.id!,
              description: descriptionController.text,
            );
        ref
            .read(selectedDateProvider.notifier)
            .update((state) => dateController.value);

        ref
            .read(selectedWalletIdProvider.notifier)
            .update((state) => walletController.value!.id);

        ref
            .read(selectedCategoryIdProvider.notifier)
            .update((state) => categoryController.value!.id);
      } else {
        final newTransaction = transaction!.copyWith(
          amount: double.parse(amountController.text),
          walletId: walletController.value!.id!,
          date: dateController.value,
          type: typeController.value!,
          categoryId: categoryController.value!.id!,
          description: descriptionController.text,
        );
        ref
            .read(incomeExpenseProvider.notifier)
            .updateTransaction(newTransaction);
      }
      (onPressed ?? AppRouter.pop).call();
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

              // Type Selection Cards
              LabeledWidget(
                label: 'Transaction Type',
                useDarkerLabel: true,
                child: TransactionTypeSelectionCards(
                  controller: typeController,
                ),
              ),

              Insets.gapH20,

              // Category
              LabeledWidget(
                label: 'Category',
                useDarkerLabel: true,
                child: CategoryDropdownField(
                  controller: categoryController,
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

              // Transfer date
              CustomDatePicker(
                firstDate: DateTime(1950),
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
      floatingActionButton: SaveButton(onSave: onSave),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    required this.onSave,
    super.key,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: FloatingActionButton(
        onPressed: onSave,
        elevation: 5,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded7,
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: Corners.rounded7,
            gradient: AppColors.buttonGradientPrimary,
          ),
          child: Center(
            child: CustomText(
              'Save',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
