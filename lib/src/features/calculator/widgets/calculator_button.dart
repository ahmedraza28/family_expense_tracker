import 'package:flutter/material.dart';

// Helpers
import '../../../global/widgets/widgets.dart';

// Widgets
import '../../../helpers/constants/constants.dart';

class CalculatorButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final double fontSize;
  final String text;
  final VoidCallback buttonTapped;

  const CalculatorButton({
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
    this.fontSize = 19,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: Corners.rounded(25),
        ),
        child: Center(
          child: CustomText(
            text,
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
