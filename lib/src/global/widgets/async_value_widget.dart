import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/networking/custom_exception.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function() loading;

  /// Used to show a custom widget when the [AsyncValue.data] is empty or null.
  final Widget Function()? emptyOrNull;

  /// Used to find the value from the [AsyncValue.data] when it is a nested list.
  final List<Object?> Function(T)? valueListFinder;

  /// Used to find the value from the [AsyncValue.data] when it is a nested map.
  final Map<Object?, Object?> Function(T)? valueMapFinder;

  /// Used to show a custom widget when the [AsyncValue.data] is empty.
  final Widget Function()? onEmpty;

  /// Used to show a custom widget when the [AsyncValue.data] is null.
  final Widget Function()? onNull;

  /// Used to show a custom widget when the [AsyncValue.data] is loaded for the first time.
  final Widget Function()? onFirstLoad;

  /// Used to show a custom widget when the [AsyncValue.data] is an error.
  final Widget Function(Object, StackTrace?) error;

  /// Used to show the [AsyncValue.data] when it is loaded successfully.
  final Widget Function(T) data;

  /// A flag to show the [emptyOrNull] widget when the [AsyncValue.data] is an error with code 'NotFoundException'.
  final bool showEmptyOnNotFoundError;

  /// A flag to show the [loading] widget when the [AsyncValue.data] is refreshing.
  final bool showLoadingOnRefresh;

  const AsyncValueWidget({
    required this.value,
    required this.loading,
    required this.error,
    required this.data,
    super.key,
    this.onFirstLoad,
    this.valueListFinder,
    this.valueMapFinder,
    this.emptyOrNull,
    this.onEmpty,
    this.onNull,
    this.showEmptyOnNotFoundError = false,
    this.showLoadingOnRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    if (showLoadingOnRefresh && value.isRefreshing) return loading();
    return value.when(
      loading: onFirstLoad ?? loading,
      error: (ex, st) {
        if (showEmptyOnNotFoundError && emptyOrNull != null) {
          if (ex is CustomException && ex.code == 'NotFoundException') {
            return emptyOrNull!.call();
          }
        }
        return error(ex, st);
      },
      data: (d) {
        final dataObj =
            valueListFinder?.call(d) ?? valueMapFinder?.call(d) ?? d;
        if (emptyOrNull != null &&
            (dataObj == null ||
                (dataObj is Iterable && dataObj.isEmpty) ||
                (dataObj is Map && dataObj.isEmpty))) {
          return emptyOrNull!.call();
        } else if (onEmpty != null && (dataObj is List && dataObj.isEmpty)) {
          return onEmpty!.call();
        } else if (onNull != null && dataObj == null) {
          return onNull!.call();
        }
        return data(d);
      },
    );
  }
}
