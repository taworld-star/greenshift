import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenshift/data/service/httpservice.dart';
import 'package:greenshift/data/model/user_model.dart';

class AuthRepository {
  final HttpService _httpService = HttpService();

  // LOGIN USER
  Future<UserResponse?> login(String email, String password) async {
    try {
      final response = await _httpService.post('/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Mengubah JSON Mentah -> Jadi Object UserResponse
        final data = UserResponse.fromJson(response.body);
        
        //Menyimpan token
        final jsonMap = jsonDecode(response.body);
        if (jsonMap['token'] != null) {
            await _saveToken(jsonMap['token']);
        }
        
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error Login: $e");
      return null;
    }
  }

  // Menyimpan token ke memori hp 
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}