import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models

// Providers

// Helpers
import '../../../helpers/constants/app_utils.dart';
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';

// Widgets
import '../widgets/add_book_fab.dart';
import '../widgets/books_list.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Books'),
      ),
      body: const BooksList(),
      floatingActionButton: OpenContainer(
        openElevation: 0,
        closedElevation: 5,
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: AppColors.primaryColor,
        middleColor: AppColors.lightPrimaryColor,
        closedShape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded50,
        ),
        tappable: false,
        transitionDuration: Durations.medium,
        closedBuilder: (ctx, openFunction) => AddBookFab(
          onPressed: openFunction,
        ),
        openBuilder: (ctx, closeFunction) => const SizedBox.shrink(),
      ),
    );
  }
}
