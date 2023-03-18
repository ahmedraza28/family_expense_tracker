import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderLogger implements ProviderObserver {
  const ProviderLogger();

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '[ProviderUpdated: ${provider.name ?? provider.runtimeType}], previous: $previousValue, new: $newValue',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('[ProviderDisposed: ${provider.name ?? provider.runtimeType}]');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint(
      '''[ProviderFailed: ${provider.name ?? provider.runtimeType}]'''
      '''\nError: $error'''
      '''\nStackTrace: $stackTrace''',
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '[ProviderAdded: ${provider.name ?? provider.runtimeType}], value: $value',
    );
  }
}
