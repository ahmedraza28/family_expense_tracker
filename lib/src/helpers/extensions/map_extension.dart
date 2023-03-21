import 'package:collection/collection.dart';

extension MapExtensions<K, V> on Map<K, V> {
  /// Finds key by value
  K? findKeyByValue(V? value) {
    return entries.firstWhereOrNull((element) => element.value == value)?.key;
  }
}
