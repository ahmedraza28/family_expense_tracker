import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class FloatingSaveButton extends StatelessWidget {
  const FloatingSaveButton({
    required this.onSave,
    super.key,
    this.isDisabled = false,
  });

  final VoidCallback onSave;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: FloatingActionButton(
        onPressed: isDisabled ? null : onSave,
        elevation: 5,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded7,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: Corners.rounded7,
            gradient: isDisabled
                ? AppColors.buttonGradientGrey
                : AppColors.buttonGradientPrimary,
          ),
          child: const Center(
            child: CustomText(
              'Save',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
