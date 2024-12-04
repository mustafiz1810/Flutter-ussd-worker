import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config.dart';

class ApiHandler {
  static Future<void> sendUssdResponse({
    required String status,
    required String response,
    required String id,
  }) async {
    String apiUrl = "${AppConfig.BASE_URL}/request-response/$id";
    try {

      // Log the request being made
      print("Calling POST API..."+id);
      print("API URL: $apiUrl");

      // Make the HTTP POST request
      final http.Response result = await http.post(
        Uri.parse(apiUrl),
        headers: {"Accept": "*/*"},
        body: {
          "status": status,
          "response": response,
        },
      );

      // Log the response status and body after the request
      print("API Response Status Code: ${result.statusCode}");
      print("API Response Body: ${result.body}");

      if (result.statusCode == 200) {
        print("API call successful.");
      } else {
        print("API call failed with status code: ${result.statusCode}");
      }
    } catch (e) {
      // Log any errors encountered during the API call
      print("API call error: $e");
    }
  }
}
