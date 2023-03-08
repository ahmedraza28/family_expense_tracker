import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'book_list_item.dart';

class BooksList extends ConsumerWidget {
  const BooksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksStream = ref.watch(booksStreamProvider);
    return booksStream.maybeWhen(
      data: (books) => ListView.separated(
        itemCount: books.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH15,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        itemBuilder: (_, i) {
          return BookListItem(
            book: books[i],
          );
        },
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}
