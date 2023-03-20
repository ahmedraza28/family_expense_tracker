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
    final categoryTextController = useTextEditingController(
      text: categoryController.value?.name ?? '',
    );
    final walletTextController = useTextEditingController(
      text: walletController.value?.name ?? '',
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
                  floatingText: 'Amount',
                ),
              ),

              Insets.gapH20,

              // Category
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: () async {
                  // ref.runAsync(
                  // isCategorySelectableProvider,
                  // () async {
                  ref
                      .read(isCategorySelectableProvider.notifier)
                      .update((_) => true);
                  final category = await AppRouter.pushNamed(
                    Routes.CategoriesScreenRoute,
                  ) as CategoryModel;
                  categoryController.value = category;
                  categoryTextController.text = category.name;
                  //   },
                  // );
                },
                child: CustomTextField(
                  controller: categoryTextController,
                  enabled: false,
                  hintText: 'Tap to select',
                  floatingText: 'Category',
                ),
              ),

              Insets.gapH20,

              // Wallet
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
                  walletController.value = wallet;
                  walletTextController.text = wallet.name;
                },
                child: CustomTextField(
                  controller: walletTextController,
                  enabled: false,
                  hintText: 'Tap to select',
                  floatingText: 'Wallet',
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
