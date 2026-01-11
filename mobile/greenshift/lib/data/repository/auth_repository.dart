import 'package:greenshift/data/usecase/response/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenshift/data/service/httpservice.dart';

class AuthRepository {
  final HttpService _httpService = HttpService();

  // LOGIN USER
  Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await _httpService.post('/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.body);
        
        //Menyimpan token ke memori HP
        if (authResponse.token != null) {
            await _saveToken(authResponse.token!);
        }
        
        return authResponse;
      } else {
        return AuthResponse.fromJson(response.body);
      }
    } catch (e) {
      print("Error Login: $e");
      return null;
    }
  }

  //Register
  Future<AuthResponse?> register ({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _httpService.post('/register',
      {
        'name' : name,
        'email' : email,
        'password' : password,
        'password_confirmation' : passwordConfirmation,
      }
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.body);

        if (authResponse.token != null) {
          await _saveToken(authResponse.token!);
        }
        return authResponse;
      } else {
        return AuthResponse.fromJson(response.body);
      }
    } catch (e) {
      print("Error Register: $e");
      return null;
    }
  }

  //Logout 
  Future<bool> logout() async {
    try {
      final response = await _httpService.post('/logout', {});
      await _removeToken();

      return response.statusCode == 200;
    } catch (e) {
      print("Error Logout: $e");
      await _removeToken();
      return false;
    }
  }

  //Mengecek user apakah sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  //Mengambil token yang tersimpan
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Menyimpan token ke memori hp 
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  //Menghapus token dari memori hp
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

}