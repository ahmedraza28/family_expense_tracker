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

  const MemberRolePopupMenu({
    required this.onSelected,
    required this.onCanceled,
    required this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MemberRole?>(
      elevation: 2,
      initialValue: initialValue,
      padding: EdgeInsets.zero,
      color: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded20,
      ),
      itemBuilder: (_) => [
        for (var status in MemberRole.values)
          PopupMenuItem(
            value: status,
            height: 38,
            child: CustomText(
              status.name.removeUnderScore,
              maxLines: 1,
            ),
          ),
      ],
      onSelected: onSelected,
      onCanceled: onCanceled,
      child: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
        size: 22,
      ),
    );
  }
}
