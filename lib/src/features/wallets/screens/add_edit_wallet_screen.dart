import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/extensions/object_extensions.dart';
import '../../../helpers/form_validator.dart';

// Providers
import '../../balance_adjustment/balance_adjustment.dart';
import '../providers/currencies_provider.codegen.dart';
import '../providers/wallets_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../shared/shared.dart';
import '../../calculator/calculator.dart';

class AddEditWalletScreen extends HookConsumerWidget {
  final WalletModel? wallet;
  final VoidCallback? onPressed;

  const AddEditWalletScreen({
    super.key,
    this.wallet,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      balanceAdjustmentProvider,
      (_, next) => next.whenOrNull(
        data: (_) => AppUtils.showFlushBar(
          context: context,
          message: 'Balance adjusted successfully',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (error, stack) => AppUtils.showFlushBar(
          context: context,
          message: error.toString(),
          iconColor: Colors.red,
        ),
      ),
    );

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final walletNameController = useTextEditingController(
      text: wallet?.name ?? '',
    );
    final walletBalanceController = useTextEditingController(
      text: wallet?.balance.toString() ?? '',
    );
    final colorController = useValueNotifier<Color>(
      wallet?.color ?? AppColors.primaryColor,
    );

    void onSave() {
      if (!formKey.currentState!.validate() || colorController.value.isNull) {
        return;
      }
      formKey.currentState!.save();
      if (wallet == null) {
        ref.read(walletsProvider.notifier).addWallet(
              name: walletNameController.text,
              color: colorController.value,
              balance: double.parse(walletBalanceController.text),
            );
      } else {
        final newWallet = wallet!.copyWith(
          name: walletNameController.text,
          color: colorController.value,
        );
        ref.read(walletsProvider.notifier).updateWallet(newWallet);
      }
      (onPressed ?? AppRouter.pop).call();
    }

    void editBalance() {
      AppRouter.pushNamed(Routes.AddEditBalanceAdjustmentScreenRoute);
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          wallet != null ? 'Edit a wallet' : 'Add a new wallet',
          fontSize: 20,
        ),
        actions: [
          // Delete Button
          if (wallet != null)
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
              ),

              Insets.gapH20,

              // Wallet Color And Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Name
                  Expanded(
                    child: CustomTextField(
                      controller: walletNameController,
                      floatingText: 'Wallet Name',
                      hintText: 'Enter wallet name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: FormValidator.nonEmptyValidator,
                    ),
                  ),

                  Insets.gapW10,

                  // Wallet Color
                  Padding(
                    padding: const EdgeInsets.only(top: 23),
                    child: ColorPickerButton(
                      controller: colorController,
                      iconData: Icons.wallet_rounded,
                    ),
                  )
                ],
              ),

              Insets.gapH20,

              // Wallet Balance
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded7,
                ),
                onTap: wallet != null
                    ? null
                    : () async {
                        await AppRouter.pushNamed(
                          Routes.CalculatorScreenRoute,
                        );
                        walletBalanceController.text =
                            ref.read(numberResultProvider);
                      },
                child: CustomTextField(
                  controller: walletBalanceController,
                  enabled: false,
                  floatingText: 'Balance',
                  hintText: '0.0',
                  prefix: Consumer(
                    builder: (context, ref, child) {
                      final currency = ref.watch(selectedBookCurrencyProvider);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 9, 0, 0),
                        child: CustomText.body(
                          currency.symbol,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGreyColor,
                        ),
                      );
                    },
                  ),
                  suffix: wallet == null
                      ? null
                      : Consumer(
                          builder: (context, ref, child) {
                            final state = ref.watch(balanceAdjustmentProvider);
                            return state.maybeWhen(
                              loading: () => const CustomCircularLoader(
                                color: AppColors.textGreyColor,
                              ),
                              orElse: () => InkWell(
                                onTap: editBalance,
                                customBorder: const RoundedRectangleBorder(
                                  borderRadius: Corners.rounded7,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColors.textGreyColor,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                  validator: FormValidator.nonEmptyValidator,
                ),
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
