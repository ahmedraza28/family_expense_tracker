import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';

extension AsyncGuardedRequest<T> on AsyncValue<T> {
  Future<AsyncValue<T>> makeGuardedRequest(
    Future<T> Function() callback, {
    String? errorMessage,
  }) async {
    try {
      final result = await callback.call();
      return AsyncValue.data(result);
    } on CustomException catch (ex, st) {
      debugPrintStack(label: ex.message, stackTrace: st);
      final message = ex.toString().split(':').last.trim();
      final reason = message.isNotEmpty
          ? message
          : (errorMessage ?? 'Guarded future request failed.');
      return AsyncValue.error(reason, st);
    }
  }
}

extension WidgetRefExtension on WidgetRef {
  Future<void> runAsync(
    ProviderListenable<Object?> provider,
    Future<void> Function() cb,
  ) async {
    final sub = listenManual(provider, (prev, value) {});
    await cb();
    sub.close();
  }
}

extension StateRefExtension on AutoDisposeStateProviderRef<Object?> {
  void delayDispose() {
    keepAlive();
    onCancel(invalidateSelf);
  }
}

extension NotifierRefExtension on AutoDisposeNotifierProviderRef<Object?> {
  void delayDispose() {
    keepAlive();
    onCancel(invalidateSelf);
  }
}
