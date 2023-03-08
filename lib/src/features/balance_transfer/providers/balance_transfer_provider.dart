import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

final editBalanceTransferProvider =
    StateProvider.autoDispose<BalanceTransferModel?>((_) => null);
