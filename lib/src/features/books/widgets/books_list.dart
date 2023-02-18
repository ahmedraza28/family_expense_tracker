import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import 'book_list_item.dart';

class BooksList extends StatelessWidget {
  const BooksList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      separatorBuilder: (_, __) => Insets.gapH15,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      itemBuilder: (_, i) {
        return BookListItem(
          onTap: () {},
        );
      },
    );
  }
}
