import 'package:flutter/material.dart';

// Helpers
import '../../helpers/constants/app_colors.dart';
import '../../helpers/extensions/extensions.dart';

enum LabelPosition {
  start,
  end;

  VerticalDirection get direction => this == LabelPosition.start
      ? VerticalDirection.down
      : VerticalDirection.up;
}

class LabeledWidget extends StatelessWidget {
  final Widget child;
  final String label;
  final double labelGap;
  final TextStyle? labelStyle;
  final bool useDarkerLabel;
  final Axis labelDirection;
  final LabelPosition labelPosition;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final bool expand;

  const LabeledWidget({
    required this.child,
    required this.label,
    super.key,
    this.labelGap = 5,
    this.labelPosition = LabelPosition.start,
    this.expand = false,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.labelDirection = Axis.vertical,
    this.useDarkerLabel = false,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      // Label
      Text(
        label,
        style: useDarkerLabel
            ? const TextStyle(color: AppColors.textBlackColor)
            : (labelStyle ??
                context.theme.inputDecorationTheme.floatingLabelStyle),
      ),

      if (labelDirection == Axis.vertical)
        SizedBox(height: labelGap)
      else
        SizedBox(width: labelGap),

      // Widget
      if (expand) Expanded(child: child) else child,
    ];
    return labelDirection == Axis.vertical
        ? Column(
            verticalDirection: labelPosition.direction,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: children,
          )
        : Row(
            verticalDirection: labelPosition.direction,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: children,
          );
  }
}
