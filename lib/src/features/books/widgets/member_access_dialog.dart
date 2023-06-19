import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'hangout_request_status_popup_menu.dart';

// Features
import '../../auth/auth.dart';
import '../../shared/shared.dart';
import '../books.dart';

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
        width: 250,
        child: Column(
          children: [
            // Grey Container
            Expanded(
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.rounded20,
                ),
                color: AppColors.surfaceColor,
                child: MemberList(
                  members: membersMap,
                  bookId: bookId,
                ),
              ),
            ),

            // Save Button
            const FloatingSaveButton(
              onSave: AppRouter.pop,
            )
          ],
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
    final state = ref.watch(usersProvider(members.keys.toList()));
    return state.maybeWhen(
      data: (data) => ListView.separated(
        itemCount: members.length,
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
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
    return ListTile(
      dense: true,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      trailing: LabeledWidget(
        labelDirection: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        label: member.role.name.removeUnderScore,
        child: MemberRolePopupMenu(
          initialValue: member.role,
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
      leading: CustomNetworkImage(
        imageUrl: member.imageUrl ?? '',
        width: 40,
        height: 40,
        shape: BoxShape.circle,
        errorWidget: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText.title(
              name[0],
              fontSize: 18,
              color: AppColors.textWhite80Color,
            ),
          ),
        ),
      ),
      title: CustomText.subtitle(name),
    );
  }
}
