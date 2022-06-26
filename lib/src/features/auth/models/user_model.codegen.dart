import 'package:freezed_annotation/freezed_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

part 'user_model.codegen.freezed.dart';
part 'user_model.codegen.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String username,
    required String name,
    required String email,
    required String profilePictureUrl,
  }) = _UserModel;

  factory UserModel.fromJson(JSON json) => _$UserModelFromJson(json);
}
