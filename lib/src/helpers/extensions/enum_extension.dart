import 'string_extension.dart';

/// A utility with extensions for strings.
extension EnumExt on Enum {
  /// An extension for converting Enum to displayable String name.
  String get sanitizedName => name.removeUnderScore.capitalize;
}
