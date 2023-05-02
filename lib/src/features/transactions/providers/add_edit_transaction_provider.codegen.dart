import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedWalletIdProvider = StateProvider<String?>(
  name: 'selectedWalletIdProvider',
  (ref) {
    return null;
  },
);

final selectedCategoryIdProvider = StateProvider<String?>(
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
