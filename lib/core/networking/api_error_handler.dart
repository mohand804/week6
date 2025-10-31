import 'package:dio/dio.dart';
import 'package:week6/core/networking/api_error_factory.dart';
import 'package:week6/core/networking/local_status_codes.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            message: "Connection to server failed",
            statusCode: LocalStatusCodes.internalServerError,
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            message: "Request to the server was cancelled",
            statusCode: LocalStatusCodes.badRequest,
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            message: "Connection timeout with the server",
            statusCode: LocalStatusCodes.badRequest,
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            message:
                "Connection to the server failed due to internet connection",
            statusCode: LocalStatusCodes.badRequest,
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: "Receive timeout in connection with the server",
            statusCode: LocalStatusCodes.badRequest,
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: "Send timeout in connection with the server",
            statusCode: LocalStatusCodes.badRequest,
          );
        default:
          return ApiErrorModel(
            message: "Something went wrong",
            statusCode: LocalStatusCodes.badRequest,
          );
      }
    } else {
      return ApiErrorFactory.defaultError;
    }
  }
}

ApiErrorModel _handleError(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ApiErrorModel(
      message: data['message'] ?? "Invalid credentials",
      statusCode: data['code'] ?? LocalStatusCodes.badRequest,
    );
  }
  return ApiErrorFactory.defaultError;
}
