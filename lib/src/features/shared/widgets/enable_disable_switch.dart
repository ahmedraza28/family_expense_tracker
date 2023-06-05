import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

class EnableDisableSwitch extends StatelessWidget {
  const EnableDisableSwitch({
    required this.controller,
    super.key,
  });

  final ValueNotifier<bool> controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_, isEnabled, __) {
        return Switch.adaptive(
          activeColor: AppColors.primaryColor,
          value: isEnabled,
          onChanged: (value) => controller.value = value,
        );
      },
    );
  }
}
