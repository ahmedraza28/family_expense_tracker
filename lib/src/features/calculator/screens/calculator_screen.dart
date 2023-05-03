import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/context_extensions.dart';

// Enums
import '../enums/calc_button_enum.dart';

// Providers
import '../providers/calculator_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/calculation_history_dialog.dart';
import '../widgets/calculator_button.dart';

/// Dark Colors
class ButtonColors {
  static const btnBgColor = AppColors.textBlueGreyColor;
  static const btnDarkBgColor = Color.fromARGB(255, 36, 40, 53);
  static const btnBlueBgColor = AppColors.lightPrimaryColor;
  static const sheetBgColor = AppColors.fieldFillColor;
  static const operatorColor = AppColors.lightPrimaryColor;
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  void showHistoryDialog(BuildContext context) {
    showGeneralDialog(
      barrierColor: AppColors.barrierColorLight,
      transitionDuration: const Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      transitionBuilder: (context, a1, a2, dialog) {
        final curveValue =
            (1 - Curves.linearToEaseOut.transform(a1.value)) * 200;
        return Transform(
          transform: Matrix4.translationValues(curveValue, 0, 0),
          child: Opacity(opacity: a1.value, child: dialog),
        );
      },
      pageBuilder: (_, __, ___) => const CalculationHistoryDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => showHistoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Output Section
          const Expanded(
            child: NumberResult(),
          ),

          // Input Section
          SizedBox(
            height: context.screenHeight * 0.51,
            child: const InputButtons(),
          ),
        ],
      ),
    );
  }
}

class InputButtons extends ConsumerWidget {
  const InputButtons({super.key});

  static const List<CalcButton> buttons = [
    CalcButton.CLEAR,
    CalcButton.DELETE,
    CalcButton.PERCENT,
    CalcButton.DIVIDE,
    CalcButton.SEVEN,
    CalcButton.EIGHT,
    CalcButton.NINE,
    CalcButton.MULTIPLY,
    CalcButton.FOUR,
    CalcButton.FIVE,
    CalcButton.SIX,
    CalcButton.SUBTRACT,
    CalcButton.ONE,
    CalcButton.TWO,
    CalcButton.THREE,
    CalcButton.ADD,
    CalcButton.ANS,
    CalcButton.ZERO,
    CalcButton.DECIMAL,
    CalcButton.EQUAL,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ButtonColors.sheetBgColor,
        boxShadow: Shadows.universalDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: buttons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.15,
          crossAxisCount: 4,
        ),
        itemBuilder: (contex, index) {
          final button = buttons[index];

          if (button.isAction) {
            return CalculatorButton(
              text: button.label,
              color: ButtonColors.btnBlueBgColor,
              textColor: AppColors.textWhite80Color,
              buttonTapped: () {
                if (button == CalcButton.CLEAR) {
                  ref.read(numberInputProvider.notifier).clear();
                } else if (button == CalcButton.DELETE) {
                  ref.read(numberInputProvider.notifier).delete();
                } else if (button == CalcButton.EQUAL) {
                  final result = ref.read(numberResultProvider);
                  final input = ref.read(numberInputProvider);
                  if (input == result) {
                    AppRouter.pop();
                  } else {
                    ref.read(numberInputProvider.notifier).equal();
                  }
                } else if (button == CalcButton.ANS) {
                  ref.read(numberInputProvider.notifier).ans();
                }
              },
            );
          }
          return CalculatorButton(
            text: button.label,
            fontSize: button.isOperator ? 21 : 19,
            color: button.isOperator
                ? ButtonColors.btnDarkBgColor
                : ButtonColors.btnBgColor,
            textColor: button.isOperator
                ? ButtonColors.operatorColor
                : AppColors.textBlackColor,
            buttonTapped: () {
              ref.read(numberInputProvider.notifier).onBtnTapped(button.label);
            },
          );
        },
      ),
    );
  }
}

class NumberResult extends StatelessWidget {
  const NumberResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Input Text
          Consumer(
            builder: (_, ref, __) {
              final input = ref.watch(numberInputProvider);
              return Container(
                alignment: Alignment.centerRight,
                child: CustomText(
                  input,
                  color: AppColors.textBlackColor,
                  fontSize: 25,
                ),
              );
            },
          ),

          Insets.gapH10,

          // Output Section
          Consumer(
            builder: (_, ref, __) {
              final output = ref.watch(numberResultProvider);
              return Container(
                alignment: Alignment.bottomRight,
                child: CustomText(
                  output,
                  color: AppColors.textGreyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
