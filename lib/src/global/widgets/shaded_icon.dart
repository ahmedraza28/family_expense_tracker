import 'package:flutter/material.dart';

// Helpers
import '../../helpers/constants/constants.dart';

class ShadedIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  const ShadedIcon({
    required this.color,
    required this.iconData,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = Corners.rounded9,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
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
