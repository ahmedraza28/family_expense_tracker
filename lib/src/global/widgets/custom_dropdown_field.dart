// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Helpers
import '../../helpers/constants/app_colors.dart';
import '../../helpers/constants/app_styles.dart';

// Widgets
import './custom_dropdown_sheet.dart';
import './custom_text_button.dart';

abstract class CustomDropdownField<T> extends HookWidget {
  const CustomDropdownField({super.key});

  factory CustomDropdownField.sheet({
    required CustomDropdownSheet<T> itemsSheet,
    required Widget Function(T) selectedItemBuilder,
    Key? key,
    ValueNotifier<T?>? controller,
    Widget suffixIcon,
    TextStyle selectedStyle,
    double height,
    Color displayFieldColor,
    EdgeInsets padding,
    String hintText,
    T? initialValue,
  }) = _CustomDropdownFieldSheet;

  const factory CustomDropdownField.animated({
    required ValueNotifier<T?> controller,
    required Map<String, T> items,
    void Function(T?)? onSelected,
    Key? key,
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? selectedStyle,
    TextStyle? listItemStyle,
    Color fillColor,
    BorderRadius borderRadius,
    bool enableSearch,
  }) = _CustomDropdownFieldAnimated;

  @override
  Widget build(BuildContext context);
}

class _CustomDropdownFieldSheet<T> extends CustomDropdownField<T> {
  /// The notifier used to store and passback selected values to the parent.
  final ValueNotifier<T?> controller;

  /// The icon to display at the end of the field.
  final Widget suffixIcon;

  /// The [TextStyle] used for displaying selected value in the field.
  final TextStyle selectedStyle;

  /// The [Color] used for filling background of the field.
  final Color displayFieldColor;

  /// The initial hint set for the field.
  final String hintText;

  /// The bottom modal sheet used to display dropdown items
  final CustomDropdownSheet<T> itemsSheet;

  /// This callback is used to map the selected value to a
  /// [Widget] for displaying.
  final Widget Function(T) selectedItemBuilder;

  /// The initial value to be selected in the dropdown
  final T? initialValue;

  /// The value of content padding around the field.
  final EdgeInsets padding;

  /// The height of the display field.
  final double height;

  /// The background color of the dropdown sheet.
  final Color backgroundColor;

  _CustomDropdownFieldSheet({
    required this.itemsSheet,
    required this.selectedItemBuilder,
    super.key,
    ValueNotifier<T?>? controller,
    this.suffixIcon = const Icon(
      Icons.arrow_drop_down_rounded,
      color: AppColors.textGreyColor,
    ),
    this.selectedStyle = const TextStyle(
      fontSize: 16,
      color: AppColors.textGreyColor,
    ),
    this.displayFieldColor = AppColors.fieldFillColor,
    this.backgroundColor = AppColors.surfaceColor,
    this.height = 47,
    this.hintText = 'Select a value',
    this.padding = const EdgeInsets.only(left: 20, right: 15),
    this.initialValue,
  }) : controller = controller ?? ValueNotifier(initialValue);

  Future<void> _pickValue(BuildContext context) async {
    controller.value = await showModalBottomSheet<T?>(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          backgroundColor: backgroundColor,
          context: context,
          builder: (context) {
            return itemsSheet;
          },
        ) ??
        controller.value;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      height: height,
      onPressed: () => _pickValue(context),
      color: displayFieldColor == Colors.transparent ? null : displayFieldColor,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<T?>(
            valueListenable: controller,
            builder: (_, value, __) => value != null
                ? selectedItemBuilder(value)
                : Text(
                    hintText,
                    style: selectedStyle,
                  ),
          ),

          // Icon
          suffixIcon,
        ],
      ),
    );
  }
}

class _CustomDropdownFieldAnimated<T> extends CustomDropdownField<T> {
  /// The initial hint set for the field.
  final String? hintText;

  /// The [TextStyle] used for displaying hint text in the field.
  final TextStyle? hintStyle;

  /// The [TextStyle] used for displaying selected value in the field.
  final TextStyle? selectedStyle;

  /// The [TextStyle] used for displaying list items in the dropdown.
  final TextStyle? listItemStyle;

  /// The [Color] used for filling background of the field.
  final Color fillColor;

  /// The [BorderRadius] used for rounding the corners of the field.
  final BorderRadius borderRadius;

  /// The callback used to passback selected value to the parent.
  final void Function(T?)? onSelected;

  /// The items to be displayed in the dropdown.
  final Map<String, T> items;

  /// The flag used to enable/disable search in the dropdown.
  final bool enableSearch;

  /// The icon to display at the end of the field.
  final Widget fieldSuffixIcon;

  /// The notifier used to store and passback selected values to the parent.
  final ValueNotifier<T?> controller;

  const _CustomDropdownFieldAnimated({
    required this.controller,
    required this.items,
    super.key,
    this.onSelected,
    this.hintText,
    this.listItemStyle,
    this.hintStyle = const TextStyle(
      fontSize: 16,
      color: AppColors.textGreyColor,
    ),
    this.selectedStyle = const TextStyle(
      fontSize: 16,
      color: AppColors.textGreyColor,
    ),
    this.fieldSuffixIcon = const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 22,
    ),
    this.fillColor = AppColors.fieldFillColor,
    this.borderRadius = Corners.rounded7,
    this.enableSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final searchItems = <String>[hintText ?? 'Select value', ...items.keys];
    return enableSearch
        ? CustomDropdown.search(
            controller: textController,
            items: searchItems,
            onChanged: (label) {
              textController.text = label == hintText ? '' : label;
              onSelected?.call(items[label]);
            },
            hintText: hintText,
            hintStyle: hintStyle,
            selectedStyle: selectedStyle,
            listItemStyle: listItemStyle,
            borderRadius: borderRadius,
            fillColor: fillColor,
            fieldSuffixIcon: fieldSuffixIcon,
          )
        : CustomDropdown(
            controller: textController,
            items: searchItems,
            onChanged: (label) {
              textController.text = label == hintText ? '' : label;
              onSelected?.call(items[label]);
            },
            hintText: hintText,
            hintStyle: hintStyle,
            selectedStyle: selectedStyle,
            listItemStyle: listItemStyle,
            borderRadius: borderRadius,
            fillColor: fillColor,
            fieldSuffixIcon: fieldSuffixIcon,
          );
  }
}
