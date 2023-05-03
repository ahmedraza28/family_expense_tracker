import 'package:flutter/material.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'shaded_icon.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    required this.controller,
    required this.iconData,
    super.key,
  });

  final IconData iconData;
  final ValueNotifier<Color> controller;

  Future<void> _pickValue(BuildContext context, {required Widget sheet}) async {
    controller.value = await showModalBottomSheet<Color>(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          context: context,
          builder: (context) => sheet,
        ) ??
        controller.value;
  }

  @override
  Widget build(BuildContext context) {
    final sheet = CustomDropdownSheet<Color>.builder(
      bottomSheetTitle: 'Colors',
      builder: (_, scrollController) => GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: AppColors.primaries.length,
        itemBuilder: (_, index) {
          final color = AppColors.primaries[index];
          return InkWell(
            borderRadius: Corners.rounded7,
            onTap: () => AppRouter.pop(color),
            child: ShadedIcon(
              color: color,
              padding: const EdgeInsets.all(14),
              iconData: iconData,
            ),
          );
        },
      ),
    );
    return InkWell(
      borderRadius: Corners.rounded7,
      onTap: () => _pickValue(context, sheet: sheet),
      child: ValueListenableBuilder<Color>(
        valueListenable: controller,
        builder: (_, color, __) => ShadedIcon(
          color: color,
          height: 54,
          width: 54,
          iconData: iconData,
        ),
      ),
    );
  }
}
