import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedWalletIdProvider = StateProvider<int?>(
  name: 'selectedWalletIdProvider',
  (ref) {
    return null;
  },
);

final selectedCategoryIdProvider = StateProvider<int?>(
  name: 'selectedCategoryIdProvider',
  (ref) {
    return null;
  },
);

final selectedDateProvider = StateProvider<DateTime?>(
  name: 'selectedDateProvider',
  (ref) {
    return null;
  },
);
