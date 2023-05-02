import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Models
import '../models/currency_model.codegen.dart';

part 'currencies_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
CurrenciesRepository currenciesRepository(CurrenciesRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return CurrenciesRepository(firestoreService);
  // return MockCurrenciesRepository();
}

class CurrenciesRepository {
  final FirestoreService _firestoreService;

  const CurrenciesRepository(this._firestoreService);

  Stream<List<CurrencyModel>> getAllCurrencies() {
    return _firestoreService.collectionStream<CurrencyModel>(
      path: 'currencies',
      builder: (json, docId) => CurrencyModel.fromJson(json!),
    );
  }
}

class MockCurrenciesRepository implements CurrenciesRepository {
  @override
  Stream<List<CurrencyModel>> getAllCurrencies() {
    return Stream.value(const [
      CurrencyModel(name: 'PKR', symbol: 'Rs'),
      CurrencyModel(name: 'USD', symbol: r'$'),
      CurrencyModel(name: 'EUR', symbol: '€'),
      CurrencyModel(name: 'GBP', symbol: '£'),
      CurrencyModel(name: 'INR', symbol: '₹'),
    ]);
  }

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
