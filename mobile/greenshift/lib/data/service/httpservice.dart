import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  //Konfigurasi IP
  static const String _ipUrl = "10.16.242.164";
  final String baseUrl = "http://$_ipUrl:8000/api";
  final String aiUrl = "http://$_ipUrl:5000";

  // ambil header & token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  //CRUD
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(); 
    
    final response = await http.get(url, headers: headers);
    
    log('GET $url : ${response.statusCode}');
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String,dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    log('POST $url: ${response.statusCode}');
    return response;
  }

  Future<http.Response> postAuth(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> postWithFile(String endpoint, Map<String, String> fields, File? file,
  String fileName, {
  bool isPython = false,
  }
  ) async {
    try{
      final base = isPython ? aiUrl : baseUrl;
      final url = Uri.parse('$base$endpoint');

      final request = http.MultipartRequest('POST', url);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll(fields);

      if(file != null) {
        final imageFile = await http.MultipartFile.fromPath(
          fileName,
          file.path,
        );
        request.files.add(imageFile);
      }
      log('POST FILE to: $url');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log('Response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('Error in postWithFile: $e');
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    log('PUT $url : ${response.statusCode}');
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);

    log('DELETE $url : ${response.statusCode}');
    return response;

  }
}
