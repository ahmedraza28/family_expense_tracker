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
  final List<String> bookIds;

  const BooksList({
    required this.bookIds,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(booksStreamProvider(bookIds: bookIds)),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 70),
        child: CustomCircularLoader(),
      ),
      error: (error, st) => ErrorResponseHandler(
        error: error,
        retryCallback: () {},
        stackTrace: st,
      ),
      emptyOrNull: () => const EmptyStateWidget(
        height: 395,
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        title: 'No transactions recorded yet',
        subtitle: 'Check back later',
      ),
      data: (books) {
        books.sort((a, b) => a.name.compareTo(b.name));
        return ListView.separated(
          itemCount: books.length,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          separatorBuilder: (_, __) => Insets.gapH15,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 90),
          itemBuilder: (_, i) {
            return BookListItem(
              book: books[i],
            );
          },
        );
      },
    );
  }
}
