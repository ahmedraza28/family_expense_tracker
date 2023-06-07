import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Providers
import '../providers/wallets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'wallets_list.dart';

class WalletsView extends ConsumerStatefulWidget {
  const WalletsView({super.key});

  @override
  ConsumerState<WalletsView> createState() => WalletsViewState();
}

class WalletsViewState extends ConsumerState<WalletsView> {
  int _selectedSegmentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AsyncValueWidget(
        value: ref.watch(walletsStreamProvider),
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 70),
          child: CustomCircularLoader(),
        ),
        error: (error, st) => ErrorResponseHandler(
          error: error,
          retryCallback: () {},
          stackTrace: st,
        ),
        emptyOrNull: () => const EmptyStateWidget(
          height: 395,
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
          title: 'No wallets built yet',
          subtitle: 'Check back later',
        ),
        data: (wallets) {
          final enabledWallets = <WalletModel>[];
          final disabledWallets = <WalletModel>[];

          for (final wallet in wallets) {
            if (wallet.isEnabled) {
              enabledWallets.add(wallet);
            } else {
              disabledWallets.add(wallet);
            }
          }

          return Column(
            children: [
              // Filters
              CupertinoSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Enabled',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 0
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Disabled',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 1
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                },
                padding: const EdgeInsets.all(5),
                thumbColor: AppColors.primaryColor,
                backgroundColor: Colors.white,
                groupValue: _selectedSegmentValue,
                onValueChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSegmentValue = newValue;
                    });
                  }
                },
              ),

              Insets.gapH15,

              // Wallets List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  child: _selectedSegmentValue == 0
                      ? WalletsList(
                          wallets: enabledWallets,
                        )
                      : WalletsList(
                          wallets: disabledWallets,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
