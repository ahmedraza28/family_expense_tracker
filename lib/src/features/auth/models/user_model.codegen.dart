import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../helpers/typedefs.dart';

part 'user_model.codegen.freezed.dart';
part 'user_model.codegen.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String displayName,
    required String email,
    required String? profilePictureUrl,
  }) = _UserModel;

  factory UserModel.fromFirebaseUser(User firebaseUser) => UserModel(
        uid: firebaseUser.uid,
        displayName: firebaseUser.displayName!,
        email: firebaseUser.email!,
        profilePictureUrl: firebaseUser.photoURL,
      );

  factory UserModel.fromJson(JSON json) => _$UserModelFromJson(json);
}