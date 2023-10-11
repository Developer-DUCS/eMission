import 'dart:convert';
import 'package:http/http.dart' as http;

class CalculateApiService {
  final String baseUrl = "https://www.carboninterface.com/api/v1/estimates";
  final String apiKey = "5p3VT63zAweQ6X3j8OQriw";

  Future<Map<String, dynamic>> calculateCarbonFootprint() async {
    final Uri uri = Uri.parse(baseUrl);
    final Map<String, dynamic> requestBody = {
      "type": "vehicle",
      "distance_unit": "mi",
      "distance_value": 12.0,
      "vehicle_model_id": "020174fd-7093-400b-9db7-f30d36eede3d",
    };

    final Map<String, String> headers = {
      'Authorization': 'Bearer 5p3VT63zAweQ6X3j8OQriw',
      'Content-Type': 'application/json',
    };

    final response =
        await http.post(uri, headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
