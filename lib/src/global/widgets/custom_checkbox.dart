import 'package:flutter/material.dart';

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
    return Checkbox(
      value: value ?? controller?.value ?? false,
      onChanged: (value) {
        controller?.value = value;
        onChanged?.call(value);
      },
    );
  }
}
