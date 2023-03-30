import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/currency_model.codegen.dart';

// Repositories
import '../repositories/currencies_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'currencies_provider.codegen.g.dart';

@Riverpod(keepAlive: true)
CurrencyModel selectedBookCurrency(SelectedBookCurrencyRef ref) {
  final selectedBook = ref.watch(selectedBookProvider)!;
  return ref.watch(currencyByNameProvider(selectedBook.currencyName));
}

@Riverpod(keepAlive: true)
Stream<List<CurrencyModel>> currenciesStream(CurrenciesStreamRef ref) {
  return ref.watch(currenciesProvider).getAllCurrencies();
}

@Riverpod(keepAlive: true)
Future<Map<String, CurrencyModel>> currenciesMap(CurrenciesMapRef ref) async {
  final currencies = await ref.watch(currenciesStreamProvider.future);
  return {for (var e in currencies) e.name: e};
}

@Riverpod(keepAlive: true)
CurrencyModel currencyByName(CurrencyByNameRef ref, String? name) {
  return ref.watch(currenciesMapProvider).value?[name] ??
      CurrenciesProvider.defaultCurrency;
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
CurrenciesProvider currencies(CurrenciesRef ref) {
  final currenciesRepository = ref.watch(currenciesRepositoryProvider);
  return CurrenciesProvider(currenciesRepository);
}

class CurrenciesProvider {
  final CurrenciesRepository _currenciesRepository;

  static const defaultCurrency = CurrencyModel(name: 'PKR', symbol: 'Rs');

  CurrenciesProvider(this._currenciesRepository);

  Stream<List<CurrencyModel>> getAllCurrencies() {
    return _currenciesRepository.getAllCurrencies();
  }
}
