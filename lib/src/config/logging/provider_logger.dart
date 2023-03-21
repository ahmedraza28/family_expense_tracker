import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'log_service.dart';

class ProviderLogger implements ProviderObserver {
  static final _logger = LogService.forClass('ProviderLogger');

  const ProviderLogger();

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.info(
      '[ProviderUpdated: ${provider.name ?? provider.runtimeType}], previous: $previousValue, new: $newValue',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.warn('[ProviderDisposed: ${provider.name ?? provider.runtimeType}]');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.error(
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
    _logger.info(
      '[ProviderAdded: ${provider.name ?? provider.runtimeType}], value: $value',
    );
  }
}
