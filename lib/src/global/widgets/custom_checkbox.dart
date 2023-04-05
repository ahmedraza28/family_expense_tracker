import 'package:flutter/material.dart';

import '../../helpers/extensions/extensions.dart';

class CustomCheckbox extends StatelessWidget {
  final ValueNotifier<bool?>? controller;
  final bool? value;
  final void Function(bool?)? onChanged;

  const CustomCheckbox({
    required this.value,
    this.controller,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Checkbox(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      activeColor: colorScheme.primary,
      checkColor: colorScheme.onPrimary,
      value: value ?? controller?.value ?? false,
      onChanged: (value) {
        controller?.value = value;
        onChanged?.call(value);
      },
    );
  }
}
