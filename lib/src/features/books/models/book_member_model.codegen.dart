// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';
import '../enums/member_role_enum.dart';

part 'book_member_model.codegen.freezed.dart';
part 'book_member_model.codegen.g.dart';

@freezed
class BookMemberModel with _$BookMemberModel {

  const factory BookMemberModel({
    required String? imageUrl,
    required MemberRole role,
  }) = _BookMemberModel;

  const BookMemberModel._();

  factory BookMemberModel.fromJson(JSON json) =>
      _$BookMemberModelFromJson(json);

  bool get isOwner => role == MemberRole.owner;
  bool get isEditor => role == MemberRole.editor;
  bool get isViewer => role == MemberRole.viewer;
}
