import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/book_member_model.codegen.dart';
import '../models/book_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_book_screen.dart';

// Features
import '../../shared/shared.dart';
import '../../auth/auth.dart';
import 'member_access_dialog.dart';

class BookListItem extends ConsumerWidget {
  final BookModel book;

  const BookListItem({
    required this.book,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectedBookProvider, (prev, next) {
      if (next != null && next.id == book.id) {
        AppRouter.pushNamed(Routes.BookConfigLoaderScreenRoute);
      }
    });
    final myId = ref.watch(currentUserProvider).value!.uid;
    final isOwner = book.members[myId]!.isOwner;
    final isViewer = book.members[myId]!.isViewer;
    return InkWell(
      onTap: () {
        ref.read(selectedBookProvider.notifier).update((state) => book);
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
          boxShadow: Shadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Edit
            _TitleAndEditRow(
              isOwner: isOwner,
              name: book.name,
              color: book.color,
              onEdit: () => AppRouter.push(
                AddEditBookScreen(book: book),
              ),
            ),

            const Divider(color: Colors.black, height: 0),

            // Details
            BookDetails(
              myId: myId,
              isOwner: isOwner,
              isViewer: isViewer,
              bookId: book.id,
              currencyName: book.currencyName,
              membersMap: book.members,
              description: book.description,
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  const BookDetails({
    required this.isOwner,
    required this.isViewer,
    required this.description,
    required this.myId,
    required this.bookId,
    required this.currencyName,
    required this.membersMap,
    super.key,
  });

  final String myId;
  final String bookId;
  final String description;
  final String currencyName;
  final Map<String, BookMemberModel> membersMap;
  final bool isOwner;
  final bool isViewer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Description
          if (description.isNotEmpty) ...[
            CustomText.body(description),
            Insets.gapH10,
          ],

          // Members Row
          LabeledWidget(
            label: 'Other Members',
            labelGap: 10,
            child: MemberAvatars(
              isOwner: isOwner,
              isViewer: isViewer,
              myId: myId,
              bookId: bookId,
              membersMap: membersMap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleAndEditRow extends StatelessWidget {
  const _TitleAndEditRow({
    required this.color,
    required this.name,
    required this.isOwner,
    required this.onEdit,
  });

  final Color color;
  final String name;
  final bool isOwner;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
      child: Row(
        children: [
          // Book Icon
          ShadedIcon(
            color: color,
            iconData: Icons.menu_book_rounded,
          ),

          Insets.gapW15,

          // Book Name
          CustomText.body(
            name,
            fontSize: 18,
          ),

          Insets.expand,

          // Edit button
          if (isOwner)
            CustomTextButton.gradient(
              height: 30,
              width: 55,
              onPressed: onEdit,
              gradient: AppColors.buttonGradientPrimary,
              child: Center(
                child: CustomText.subtitle(
                  'Edit',
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MemberAvatars extends StatelessWidget {
  const MemberAvatars({
    required this.membersMap,
    required this.isOwner,
    required this.myId,
    required this.bookId,
    required this.isViewer,
    super.key,
  });

  final Map<String, BookMemberModel> membersMap;
  final String myId;
  final String bookId;
  final bool isViewer;
  final bool isOwner;

  void showAccessDialog(BuildContext context) {
    showGeneralDialog(
      barrierColor: AppColors.barrierColor,
      transitionDuration: const Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      transitionBuilder: (context, a1, a2, dialog) {
        final curveValue =
            (1 - Curves.linearToEaseOut.transform(a1.value)) * 200;
        return Transform(
          transform: Matrix4.translationValues(curveValue, 0, 0),
          child: Opacity(opacity: a1.value, child: dialog),
        );
      },
      pageBuilder: (_, __, ___) => MemberAccessDialog(
        membersMap: membersMap,
        bookId: bookId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final members = <BookMemberModel>[
      for (final m in membersMap.entries)
        if (m.key != myId) m.value,
    ];
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          // Members Avatars
          SizedBox(
            width: 130,
            child: Stack(
              children: [
                if (members.isEmpty)
                  const Positioned(
                    left: 0,
                    child: CustomText(
                      'No members yet',
                      fontSize: 14,
                      color: AppColors.textGreyColor,
                    ),
                  ),

                for (int i = 0; i < members.length.clamp(0, 3); i++)
                  if (i < 3)
                    Positioned(
                      left: i * 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: members[i].imageUrl != null
                            ? CustomNetworkImage(
                                imageUrl: members[i].imageUrl!,
                                radius: 16,
                                shape: BoxShape.circle,
                              )
                            : CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primaries[i % 3],
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                // More members
                if (membersMap.length > 3)
                  Positioned(
                    left: 78,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.surfaceColor,
                        child: CustomText.subtitle(
                          '+${membersMap.length - 3}',
                          color: AppColors.textBlueGreyColor,
                        ),
                      ),
                    ),
                  ),
              ].reversed.toList(),
            ),
          ),

          // Edit users
          if (isOwner) ...[
            Insets.expand,
            InkWell(
              onTap: () => showAccessDialog(context),
              child: const CustomText(
                'Manage Access',
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            ),
          ] else if (isViewer) ...[
            Insets.expand,
            CustomChipWidget(
              content: 'Read Only',
              height: 30,
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              borderColor: Colors.transparent,
              labelStyle: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
