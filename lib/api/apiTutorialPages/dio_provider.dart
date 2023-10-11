import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

final Provider<Dio> dioProvider = Provider((ref) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/'));
  dio.interceptors
    ..add(PrettyDioLogger())
    ..add(
      InterceptorsWrapper(
        onRequest: (options, requestInterceptorHandler) =>
            requestInterceptorHandler.next(options),
        onResponse: (options, responseInterceptorHandler) =>
            responseInterceptorHandler.next(options),
        onError: (error, errorInterceptorHandler) =>
            errorInterceptorHandler.next(error),
      ),
    );
  return dio;
});
