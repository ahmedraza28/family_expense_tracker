import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Providers
import '../providers/calculator_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CalculationHistoryDialog extends StatelessWidget {
  const CalculationHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 250,
        child: Column(
          children: const [
            // Grey Container
            Expanded(
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: Corners.rounded20,
                ),
                color: AppColors.surfaceColor,
                child: HistoryList(),
              ),
            ),

            // Expand icon
            _ExpandIcon(),
          ],
        ),
      ),
    );
  }
}

class _ExpandIcon extends StatelessWidget {
  const _ExpandIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Icon(
        Icons.expand_more_sharp,
        color: Colors.white,
      ),
    );
  }
}

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculationsList = ref.watch(calculationHistoryProvider);
    return ListView.separated(
      itemCount: calculationsList.length,
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      separatorBuilder: (ctx, i) => const SizedBox(height: 20),
      itemBuilder: (ctx, i) => _HistoryListItem(
        expression: calculationsList[i],
      ),
    );
  }
}

class _HistoryListItem extends ConsumerWidget {
  const _HistoryListItem({
    required this.expression,
  });

  final String expression;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      trailing: InkWell(
        onTap: () {
          ref.read(numberInputProvider.notifier).state = expression;
          AppRouter.pop();
        },
        child: const CustomText(
          'Select',
          color: AppColors.primaryColor,
        ),
      ),
      title: CustomText.subtitle(expression),
    );
  }
}
