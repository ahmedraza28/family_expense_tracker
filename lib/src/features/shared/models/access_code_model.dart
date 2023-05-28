import '../../../helpers/typedefs.dart';
import '../../books/books.dart';

class AccessCodeModel {
  final String inviteCode;
  final MemberRole role;

  AccessCodeModel({
    required this.inviteCode,
    required this.role,
  });

  factory AccessCodeModel.fromJson(JSON json) {
    return AccessCodeModel(
      inviteCode: json['invite_code']! as String,
      role: MemberRole.values.byName(json['role']! as String),
    );
  }

  JSON toJson() {
    return {
      'invite_code': inviteCode,
      'role': role.name,
    };
  }
}
