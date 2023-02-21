import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_book_fab.dart';
import '../widgets/books_list.dart';
import 'add_edit_book_screen.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Books',
          fontSize: 20,
        ),
      ),
      body: const BooksList(),
      floatingActionButton: OpenContainer(
        openElevation: 0,
        closedElevation: 5,
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: AppColors.primaryColor,
        middleColor: AppColors.lightPrimaryColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: Corners.rounded(50),
        ),
        tappable: false,
        transitionDuration: Durations.medium,
        closedBuilder: (ctx, openFunction) => AddBookFab(
          onPressed: openFunction,
        ),
        openBuilder: (ctx, closeFunction) => const AddEditBookScreen(),
      ),
    );
  }
}
