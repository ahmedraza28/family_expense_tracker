import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

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
          // OutPut Section - Result
          SizedBox(
            height: 185,
            child: OutputSection(),
          ),

          // Input Section - Enter Numbers
          Expanded(
            child: InputSection(),
          ),
        ],
      ),
    );
  }
}

class InputSection extends StatelessWidget {
  const InputSection({super.key});

  static const List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  bool isOperator(String y) {
    if (y == '%' || y == '/' || y == 'x' || y == '-' || y == '+' || y == '=') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
                switch (index) {
                  case 0:
                    return CalculatorButton(
                      buttonTapped: () {},
                      color: ButtonColors.btnBlueBgColor,
                      textColor: AppColors.textWhite80Color,
                      text: buttons[index],
                    );

                  case 1:
                    return CalculatorButton(
                      buttonTapped: () {},
                      color: ButtonColors.btnBlueBgColor,
                      textColor: AppColors.textWhite80Color,
                      text: buttons[index],
                    );

                  case 19:
                    return CalculatorButton(
                      buttonTapped: () {},
                      color: ButtonColors.btnBlueBgColor,
                      textColor: AppColors.textWhite80Color,
                      text: buttons[index],
                    );

                  default:
                    return CalculatorButton(
                      buttonTapped: () {},
                      fontSize: isOperator(buttons[index]) ? 21 : 19,
                      color: isOperator(buttons[index])
                          ? ButtonColors.btnDarkBgColor
                          : ButtonColors.btnBgColor,
                      textColor: isOperator(buttons[index])
                          ? ButtonColors.operatorColor
                          : AppColors.textBlackColor,
                      text: buttons[index],
                    );
                }
              },
            ),
          ),

          // Save Button
          CustomTextButton.gradient(
            width: double.infinity,
            onPressed: () {
              AppRouter.pop(100);
            },
            gradient: AppColors.buttonGradientPrimary,
            child: const Center(
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

class OutputSection extends StatelessWidget {
  const OutputSection({
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
