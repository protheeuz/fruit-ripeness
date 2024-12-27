import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = '';

  static Future<Map<String, dynamic>> sendImageToModel(File imageFile) async {
    final url = Uri.parse(_baseUrl);
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        return json.decode(responseData.body);
      } else {
        throw Exception('Failed to get prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending image to model: $e');
    }
  }
}