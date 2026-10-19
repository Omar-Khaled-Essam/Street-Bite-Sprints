import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Maps Dio, Firebase, and unexpected errors into friendly copy keys/messages.
class ExceptionMapper {
  const ExceptionMapper();

  String fromObject(Object error) {
    if (error is FirebaseAuthException) {
      return fromFirebase(error.code);
    }
    if (error is DioException) {
      return 'networkError';
    }
    return 'unknownError';
  }

  String fromFirebase(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return 'Could not complete authentication. Please try again.';
    }
  }
}
