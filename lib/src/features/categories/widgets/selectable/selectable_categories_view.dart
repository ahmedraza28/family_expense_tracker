import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Models
import '../../models/category_model.codegen.dart';

// Providers
import '../../providers/categories_provider.codegen.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';
import 'selectable_categories_list.dart';

class SelectableCategoriesView extends ConsumerStatefulWidget {
  const SelectableCategoriesView({super.key});

  @override
  ConsumerState<SelectableCategoriesView> createState() => SelectableCategoriesViewState();
}

class SelectableCategoriesViewState extends ConsumerState<SelectableCategoriesView> {
  int _selectedSegmentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AsyncValueWidget(
        value: ref.watch(categoriesStreamProvider),
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
          title: 'No categories built yet',
          subtitle: 'Check back later',
        ),
        data: (categories) {
          final enabledCategories = <CategoryModel>[];
          final disabledCategories = <CategoryModel>[];

          for (final category in categories) {
            if (category.isEnabled) {
              enabledCategories.add(category);
            } else {
              disabledCategories.add(category);
            }
          }

          return Column(
            children: [
              // Filters
              CupertinoSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Enabled',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 0
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Disabled',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 1
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                },
                padding: const EdgeInsets.all(5),
                thumbColor: AppColors.primaryColor,
                backgroundColor: Colors.white,
                groupValue: _selectedSegmentValue,
                onValueChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSegmentValue = newValue;
                    });
                  }
                },
              ),

              Insets.gapH15,

              // Categories List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  child: _selectedSegmentValue == 0
                      ? SelectableCategoriesList(
                          categories: enabledCategories,
                        )
                      : SelectableCategoriesList(
                          categories: disabledCategories,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
