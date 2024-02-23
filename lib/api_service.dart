import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final int statusCode;
  final T data;

  ApiResponse(this.statusCode, this.data);
}

class ApiService {
  late String baseUrl;
  String port = '3000';

  ApiService() {
    if (kReleaseMode) {
      baseUrl = 'http://mcs.drury.edu:$port'; //replace with actual server url
    } else {
      baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:$port'
          : 'http://localhost:$port';
    }
  }

  Future<ApiResponse<T>> get<T>(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

      return ApiResponse(response.statusCode, json.decode(response.body) as T);
    } catch (e) {
      throw Exception('Get request failed.');
    }
  }

  Future<ApiResponse<T>> post<T>(
      String endpoint, Map<String, dynamic> data) async {
    print('$baseUrl/$endpoint');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return ApiResponse(response.statusCode,
          (response.body.isNotEmpty ? json.decode(response.body) : null) as T);
    } catch (e) {
      throw Exception('Post request failed.');
    }
  }

  Future<ApiResponse<T>> patch<T>(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return ApiResponse(response.statusCode,
          (response.body.isNotEmpty ? json.decode(response.body) : null) as T);
    } catch (e) {
      throw Exception('Patch request failed.');
    }
  }

  Future<ApiResponse<T>> delete<T>(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

      return ApiResponse(response.statusCode,
          (response.body.isNotEmpty ? json.decode(response.body) : null) as T);
    } catch (e) {
      print(e);
      throw Exception('Get request failed.');
    }
  }
}
