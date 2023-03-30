import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Models
import '../models/book_model.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/form_validator.dart';

// Features
import '../../auth/auth.dart';
import '../../wallets/wallets.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddEditBookScreen extends HookConsumerWidget {
  final BookModel? book;
  final VoidCallback? onPressed;

  const AddEditBookScreen({
    super.key,
    this.book,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final currencyController = useValueNotifier<CurrencyModel>(
      ref.watch(currencyByNameProvider(book?.currencyName)),
    );
    final bookNameController = useTextEditingController(text: book?.name ?? '');
    final colorController = useValueNotifier<Color>(
      book?.color ?? AppColors.primaryColor,
    );

    void saveBook() {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      if (book == null) {
        final currentUser = ref.read(currentUserProvider).value!;
        ref.read(booksProvider.notifier).addBook(
              name: bookNameController.text,
              color: colorController.value,
              currencyName: currencyController.value.name,
              createdBy: currentUser,
            );
      } else {
        ref.read(booksProvider.notifier).updateBook(
              book!.copyWith(
                name: bookNameController.text,
                color: colorController.value,
                currencyName: currencyController.value.name,
              ),
            );
      }
      (onPressed ?? AppRouter.pop).call();
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          book == null ? 'Add a new book' : 'Edit book',
          fontSize: 20,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: ScrollableColumn(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Insets.gapH20,

              const CustomText(
                'Add details for a book in which you will record income and expenses',
                fontSize: 16,
                maxLines: 2,
              ),

              Insets.gapH20,

              // Book Name
              CustomTextField(
                controller: bookNameController,
                floatingText: 'Book Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
              ),

              Insets.gapH20,

              // TODO(arafaysaleem): Add color picker

              // Currency Dropdown
              Consumer(
                builder: (_, ref, __) {
                  final currencies =
                      ref.watch(currenciesStreamProvider).valueOrNull ?? [];
                  return LabeledWidget(
                    label: 'Currency',
                    useDarkerLabel: true,
                    child: CustomDropdownField<CurrencyModel>.animated(
                      controller: currencyController,
                      hintText: 'Pick a currency',
                      items: {for (var e in currencies) e.name: e},
                    ),
                  );
                },
              ),

              Insets.expand,

              // Confirm Details Button
              CustomTextButton.gradient(
                width: double.infinity,
                onPressed: saveBook,
                gradient: AppColors.buttonGradientPrimary,
                child: const Center(
                  child: CustomText(
                    'Save',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),

              Insets.bottomInsetsLow,
            ],
          ),
        ),
      ),
    );
  }
}
