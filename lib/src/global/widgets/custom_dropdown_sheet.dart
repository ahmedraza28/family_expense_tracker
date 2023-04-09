// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

/// Routing
import '../../config/routing/app_router.dart';

// Helpers
import '../../helpers/constants/constants.dart';

// Widgets
import './custom_text_button.dart';
import 'custom_text_field.dart';
import 'custom_scrollable_bottom_sheet.dart';

typedef SheetBuilder = Widget Function(BuildContext context, ScrollController);
typedef WidgetBuilder<T> = Widget Function(BuildContext context, T item);
typedef SearchFilter<T> = bool Function(String, T);

/// The sheet used to display all [CustomDropdownItem] for menu item
class CustomDropdownSheet<T> extends StatefulWidget {
  /// This gives the bottom sheet title.
  final String? bottomSheetTitle;

  /// This will give the action button text.
  final String actionButtonText;

  /// This will give the action button background color.
  final Color actionButtonColor;

  /// This will give the hint to the search text filed.
  final String? searchHintText;

  /// This will give the background color to the search text filed.
  final Color? searchBackgroundColor;

  /// This callback will decide how to filter items based on search term.
  final SearchFilter<T>? searchFilterCondition;

  /// This will display the search textfield when set to true
  final bool showSearch;

  /// This will give the list of items.
  final List<T>? items;

  /// This will give the callback to the selected items (multiple) from list.
  final void Function(List<T>)? onMultipleSelect;

  /// This will give the callback to the selected item (single) from list.
  final void Function(T)? onItemSelect;

  /// This will give selection choise for single or multiple for list.
  final bool enableMultipleSelection;

  /// The callback used to define how each dropdown item will be built.
  final WidgetBuilder<T>? itemBuilder;

  /// The callback used to define how sheet will be built.
  final SheetBuilder? builder;

  /// The widget to be displayed at the end of the sheet header
  final Widget? action;

  /// The padding added around the sheet contents
  final EdgeInsets contentPadding;

  const CustomDropdownSheet({
    super.key,
    this.items,
    this.itemBuilder,
    this.searchFilterCondition,
    this.bottomSheetTitle,
    this.searchHintText,
    this.searchBackgroundColor,
    this.onMultipleSelect,
    this.builder,
    this.action,
    this.onItemSelect,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20),
    String? actionButtonText,
    Color? actionButtonColor,
    bool? enableMultipleSelection,
    this.showSearch = false,
  })  : assert(
          (items != null && itemBuilder != null) || builder != null,
          'Either sheet builder or items and itemBuilder must be provided',
        ),
        assert(
          showSearch == false || searchFilterCondition != null,
          'Search must be used with a search condition',
        ),
        this.actionButtonColor = actionButtonColor ?? AppColors.primaryColor,
        this.actionButtonText = actionButtonText ?? 'DONE',
        this.enableMultipleSelection = enableMultipleSelection ?? false;

  const factory CustomDropdownSheet.multiple({
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    Key? key,
    bool Function(String, T)? searchFilterCondition,
    String? bottomSheetTitle,
    String? actionButtonText,
    Color? actionButtonColor,
    bool showSearch,
    String? searchHintText,
    Color? searchBackgroundColor,
    void Function(List<T>)? onMultipleSelect,
    void Function(T)? onItemSelect,
  }) = _CustomDropdownSheetWithMultiSelect;

  const factory CustomDropdownSheet.builder({
    required Widget Function(BuildContext, ScrollController) builder,
    Key? key,
    String? bottomSheetTitle,
    Widget? action,
  }) = _CustomDropdownSheetWithBuilder;

  @override
  State<CustomDropdownSheet<T>> createState() => _CustomDropdownSheetState<T>();
}

class _CustomDropdownSheetState<T> extends State<CustomDropdownSheet<T>> {
  final List<T> _selectedItemList = [];
  late List<T> _filteredItemList;
  late final TextEditingController? searchController;

  @override
  void initState() {
    super.initState();
    _filteredItemList = widget.items ?? const [];
    if (widget.showSearch) {
      searchController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.showSearch) {
      searchController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollableBottomSheet(
      titleText: widget.bottomSheetTitle,
      action: Align(
        alignment: Alignment.centerRight,
        child: widget.action ??
            (!widget.enableMultipleSelection
                ? null
                : CustomTextButton(
                    color: widget.actionButtonColor,
                    width: 50,
                    height: 35,
                    onPressed: () {
                      widget.onMultipleSelect?.call(_selectedItemList);
                      _removeFocusAndPopValue<List<T>>(_selectedItemList);
                    },
                    child: Center(
                      child: Text(
                        widget.actionButtonText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
      ),
      builder: (ctx, scrollController) {
        return Padding(
          padding: widget.contentPadding,
          child: Column(
            children: [
              // A [TextField] that displays a list of suggestions as the user types with clear button.
              if (widget.showSearch) ...[
                CustomTextField(
                  controller: searchController,
                  onChanged: (_) => _onSearchChanged(),
                  border: const BorderSide(
                    color: AppColors.textLightGreyColor,
                  ),
                  textInputAction: TextInputAction.search,
                  hintText: widget.searchHintText ?? 'Search',
                  hintStyle: const TextStyle(
                    color: AppColors.textLightGreyColor,
                    fontSize: 14,
                  ),
                  prefix: const Icon(Icons.search),
                  suffix: GestureDetector(
                    onTap: _onClearTap,
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Item builder
              Expanded(
                child: widget.builder?.call(ctx, scrollController) ??
                    ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredItemList.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItemList[index];

                        return InkWell(
                          onTap: !widget.enableMultipleSelection
                              ? () {
                                  widget.onItemSelect?.call(item);
                                  _removeFocusAndPopValue<T>(item);
                                }
                              : null,
                          child: widget.itemBuilder!.call(context, item),
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  void _onSearchChanged() {
    if (searchController == null ||
        searchController!.text.isEmpty ||
        widget.searchFilterCondition == null) {
      _filteredItemList = widget.items!;
    } else {
      final fItems = <T>[];

      for (final item in widget.items!) {
        final filterItem = widget.searchFilterCondition!.call(
          searchController!.text,
          item,
        );
        if (filterItem) {
          fItems.add(item);
        }
      }
      _filteredItemList = fItems;
    }
    setState(() {});
  }

  /// This helps when want to clear text in search text field.
  void _onClearTap() {
    searchController?.clear();
    setState(() {});
  }

  /// This helps to unfocus the keyboard & pop from the bottom sheet.
  void _removeFocusAndPopValue<R>(R selected) {
    FocusScope.of(context).unfocus();
    AppRouter.pop(selected);
  }
}

class _CustomDropdownSheetWithMultiSelect<T> extends CustomDropdownSheet<T> {
  const _CustomDropdownSheetWithMultiSelect({
    required super.items,
    required super.itemBuilder,
    super.key,
    super.searchFilterCondition,
    super.bottomSheetTitle,
    super.actionButtonText,
    super.actionButtonColor,
    super.showSearch,
    super.searchHintText,
    super.searchBackgroundColor,
    super.onMultipleSelect,
    super.onItemSelect,
  }) : super(
          enableMultipleSelection: true,
        );
}

class _CustomDropdownSheetWithBuilder<T> extends CustomDropdownSheet<T> {
  const _CustomDropdownSheetWithBuilder({
    required super.builder,
    super.key,
    super.bottomSheetTitle,
    super.action,
  });
}
