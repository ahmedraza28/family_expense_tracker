import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../books.dart';

class MemberRolePopupMenu extends StatelessWidget {
  final void Function(MemberRole?) onSelected;
  final VoidCallback onCanceled;
  final MemberRole? initialValue;
  final bool enabled;

  const MemberRolePopupMenu({
    required this.onSelected,
    required this.onCanceled,
    required this.initialValue,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MemberRole?>(
      elevation: 2,
      enabled: enabled,
      initialValue: initialValue,
      padding: EdgeInsets.zero,
      color: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      itemBuilder: (_) => [
        for (var status in MemberRole.values)
          PopupMenuItem(
            value: status,
            height: 38,
            child: CustomText(
              status.name.removeUnderScore.capitalize,
              maxLines: 1,
              fontSize: 14,
            ),
          ),
      ],
      onSelected: onSelected,
      onCanceled: onCanceled,
      child: Icon(
        Icons.arrow_drop_down,
        color:
            enabled ? AppColors.lightPrimaryColor : AppColors.textBlueGreyColor,
        size: 22,
      ),
    );
  }
}
