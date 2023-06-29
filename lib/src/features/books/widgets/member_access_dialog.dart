import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../../helpers/extensions/extensions.dart';
import '../../auth/auth.dart';
import '../../shared/shared.dart';
import '../books.dart';
import 'hangout_request_status_popup_menu.dart';

class MemberAccessDialog extends StatelessWidget {
  final Map<String, BookMemberModel> membersMap;
  final String bookId;

  const MemberAccessDialog({
    required this.membersMap,
    required this.bookId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 370,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded15,
          ),
          color: AppColors.surfaceColor,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Grey Container
                Expanded(
                  child: MemberList(
                    members: membersMap,
                    bookId: bookId,
                  ),
                ),

                // Save Button
                const FloatingSaveButton(
                  margin: 0,
                  onSave: AppRouter.pop,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberList extends ConsumerWidget {
  final Map<String, BookMemberModel> members;
  final String bookId;

  const MemberList({
    required this.members,
    required this.bookId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = UserProviderParams(members.keys.toList());
    final state = ref.watch(usersProvider(params));
    return state.maybeWhen(
      data: (data) => ListView.separated(
        itemCount: members.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (ctx, i) => const SizedBox(height: 20),
        itemBuilder: (ctx, i) => _MemberListItem(
          uid: data[i].uid,
          bookId: bookId,
          name: data[i].displayName,
          member: members[data[i].uid]!,
        ),
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}

class _MemberListItem extends ConsumerWidget {
  const _MemberListItem({
    required this.name,
    required this.member,
    required this.bookId,
    required this.uid,
  });

  final BookMemberModel member;
  final String uid;
  final String bookId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.rounded10,
      ),
      child: Row(
        children: [
          // Image
          CustomNetworkImage(
            imageUrl: member.imageUrl ?? '',
            width: 30,
            height: 30,
            shape: BoxShape.circle,
            errorWidget: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomText.title(
                  name[0],
                  fontSize: 17,
                  color: AppColors.textWhite80Color,
                ),
              ),
            ),
          ),

          Insets.gapW10,

          // Name
          Expanded(
            flex: 9,
            child: CustomText(
              name,
              fontSize: 14,
              maxLines: 1,
            ),
          ),

          Insets.expand,

          // Role
          Container(
            decoration: BoxDecoration(
              borderRadius: Corners.rounded7,
              color: member.isOwner
                  ? AppColors.surfaceColor
                  : AppColors.lightPrimaryColor.withOpacity(0.15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: LabeledWidget(
              labelDirection: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              label: member.role.name.removeUnderScore.capitalize,
              labelStyle: TextStyle(
                color: member.isOwner
                    ? AppColors.textBlueGreyColor
                    : AppColors.lightPrimaryColor,
              ),
              child: MemberRolePopupMenu(
                initialValue: member.role,
                enabled: !member.isOwner,
                onCanceled: () {},
                onSelected: (status) {
                  if (member.role != status) {
                    ref.read(booksProvider.notifier).updateMemberAccess(
                          bookId: bookId,
                          memberId: uid,
                          member: member,
                        );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
