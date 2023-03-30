import 'package:flutter/material.dart';

// Helpers
import '../../helpers/constants/constants.dart';

class ShadedIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const ShadedIcon({
    required this.color,
    required this.iconData,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = Corners.rounded9,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color.withOpacity(0.2),
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 20,
          color: color,
        ),
      ),
    );
  }
}
