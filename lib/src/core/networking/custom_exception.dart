// ignore_for_file: constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// An enum that holds names for our custom exceptions.
enum _ExceptionType {
  /// The exception type for an error from one of the firebase services
  FirebaseException,

  /// The exception for an incorrect parameter in a request/response.
  FormatException,

  /// The exception for an unknown type of failure.
  UnrecognizedException,

  /// The exception for any parsing failure encountered during
  /// serialization/deserialization of a request.
  SerializationException,

  /// Unimplemented exception
  UnimplementedException,
}

class CustomException implements Exception {
  final String name;
  final String message;
  final String? code;
  final _ExceptionType exceptionType;

  CustomException({
    required this.message,
    this.code,
    this.exceptionType = _ExceptionType.UnrecognizedException,
  }) : name = exceptionType.name;

  factory CustomException.unimplemented() {
    return CustomException(
      message: 'This feature is not implemented yet',
      exceptionType: _ExceptionType.UnimplementedException,
    );
  }

  factory CustomException.fromOtherException(Exception error) {
    try {
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'weak-password':
            return CustomException(
              exceptionType: _ExceptionType.FirebaseException,
              code: error.code,
              message: 'The provided password is too weak',
            );
          case 'email-already-in-use':
            return CustomException(
              exceptionType: _ExceptionType.FirebaseException,
              code: error.code,
              message: 'The account already exists for that email.',
            );
          case 'invalid-email':
            return CustomException(
              exceptionType: _ExceptionType.FirebaseException,
              code: error.code,
              message: 'The provided email is not valid.',
            );
          case 'operation-not-allowed':
            return CustomException(
              exceptionType: _ExceptionType.FirebaseException,
              code: error.code,
              message: 'This authentication method is disabled.',
            );
        }
      } else if (error is FirebaseException){
        return CustomException(
          exceptionType: _ExceptionType.FirebaseException,
          code: error.code,
          message: error.message ?? 'Firebase error',
        );
      }
    } on FormatException catch (e) {
      return CustomException(
        exceptionType: _ExceptionType.FormatException,
        message: e.message,
      );
    } on Exception catch (_) {
      return CustomException(
        message: 'Error unrecognized',
      );
    }
    return CustomException(
      message: 'Error unrecognized',
    );
  }

  factory CustomException.fromParsingException(Exception error) {
    // TODO(arafaysaleem): add logging to print stack trace
    debugPrint('$error');
    return CustomException(
      exceptionType: _ExceptionType.SerializationException,
      message: 'Failed to parse network response to model or vice versa',
    );
  }
}
