import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Enums
import '../enums/calc_button_enum.dart';

// Providers
import '../providers/calculator_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          // Output Section
          SizedBox(
            height: 185,
            child: NumberResult(),
          ),

          // Input Section
          Expanded(
            child: InputButtons(),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: ButtonColors.sheetBgColor,
        boxShadow: Shadows.universalDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Buttons
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
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
                        ref.read(numberInputProvider.notifier).equal();
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
                    ref
                        .read(numberInputProvider.notifier)
                        .onBtnTapped(button.label);
                  },
                );
              },
            ),
          ),

          // Save Button
          const CustomTextButton.gradient(
            width: double.infinity,
            onPressed: AppRouter.pop,
            gradient: AppColors.buttonGradientPrimary,
            child: Center(
              child: CustomText(
                'Save',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
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
          Container(
            alignment: Alignment.centerRight,
            child: const Text(
              'Input Here',
              style: TextStyle(
                color: AppColors.textBlackColor,
                fontSize: 25,
              ),
            ),
          ),

          Insets.gapH10,

          // Output Section
          Container(
            alignment: Alignment.bottomRight,
            child: const Text(
              'Output Here',
              style: TextStyle(
                color: AppColors.textBlackColor,
                fontSize: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
