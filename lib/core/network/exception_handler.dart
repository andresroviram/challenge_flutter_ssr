import 'dart:io';
import 'package:dio/dio.dart';
import '../error/failures.dart';

class NetworkExceptionHandler {
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is SocketException) {
      return const NetworkFailure(message: 'No Internet connection');
    } else {
      return UnexpectedFailure(message: error.toString());
    }
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.badResponse:
        return ServerFailure(
          message: _extractErrorMessage(error),
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.cancel:
        return const UnexpectedFailure(message: 'Request cancelled');

      default:
        return UnexpectedFailure(message: error.message ?? 'Unknown error');
    }
  }

  static String _extractErrorMessage(DioException error) {
    try {
      if (error.response?.data is Map) {
        final data = error.response?.data as Map;
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
      }
      return 'Server error: ${error.response?.statusCode ?? 'Unknown'}';
    } catch (_) {
      return 'Server error occurred';
    }
  }
}
