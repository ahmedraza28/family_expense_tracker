// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';

part 'transaction_model.codegen.freezed.dart';
part 'transaction_model.codegen.g.dart';

int toCategoryId(CategoryModel category) => category.id!;
int toWalletId(WalletModel wallet) => wallet.id;

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required double amount,
    @JsonKey(toJson: toWalletId) required WalletModel wallet,
    @JsonKey(toJson: toCategoryId) required CategoryModel category,
    required DateTime date,
    String? description,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(JSON json) =>
      _$TransactionModelFromJson(json);
}
