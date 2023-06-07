import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';

// Providers
import '../providers/wallets_provider.codegen.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class WalletDropdownField extends ConsumerWidget {
  final ValueNotifier<WalletModel?> controller;
  final SelectedCallback<WalletModel>? onSelected;

  const WalletDropdownField({
    required this.controller,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(enabledWalletsStreamProvider).valueOrNull ?? [];
    return CustomDropdownField<WalletModel>.sheet(
      controller: controller,
      selectedItemBuilder: (item) => CustomText.body(item.name),
      hintText: 'Select wallet',
      itemsSheet: CustomDropdownSheet<WalletModel>(
        bottomSheetTitle: 'Wallets',
        items: wallets,
        onItemSelect: onSelected,
        itemBuilder: (_, wallet) => DropdownSheetItem(
          child: Row(
            children: [
              // Wallet name
              CustomText.body(
                wallet.name,
              ),

              Insets.expand,

              // Wallet balance
              CustomText.body(
                wallet.balance.toStringAsFixed(2),
                color: AppColors.textGreyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
