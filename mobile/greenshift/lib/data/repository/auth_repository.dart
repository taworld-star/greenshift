import 'package:greenshift/data/usecase/request/login_request.dart';
import 'package:greenshift/data/usecase/request/register_request.dart';
import 'package:greenshift/data/usecase/response/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenshift/data/service/httpservice.dart';

class AuthRepository {
  final HttpService _httpService = HttpService();

  /// LOGIN - Menggunakan LoginRequest dan AuthResponse
  Future<AuthResponse?> login(LoginRequest request) async {
    try {
      final response = await _httpService.post('/login', request.toMap());

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.body);
        
        // Menyimpan token dan role ke memori HP
        if (authResponse.token != null) {
          await _saveToken(authResponse.token!);
        }
        if (authResponse.user != null) {
          await _saveUserRole(authResponse.user!.role);
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

  /// REGISTER - Menggunakan RegisterRequest dan AuthResponse
  Future<AuthResponse?> register(RegisterRequest request) async {
    try {
      final response = await _httpService.post('/register', request.toMap());
      print('REGISTER RESPONSE: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.body);

        if (authResponse.token != null) {
          await _saveToken(authResponse.token!);
        }
        if (authResponse.user != null) {
          await _saveUserRole(authResponse.user!.role);
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

  /// LOGOUT - Menghapus token dan role
  Future<bool> logout() async {
    try {
      final response = await _httpService.post('/logout', {});
      await _removeToken();
      await _removeUserRole();

      return response.statusCode == 200;
    } catch (e) {
      print("Error Logout: $e");
      await _removeToken();
      await _removeUserRole();
      return false;
    }
  }

  /// Mengecek user apakah sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Mengecek apakah user adalah admin
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');
    return role == 'admin';
  }

  /// Mengambil role user yang tersimpan
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Mengambil token yang tersimpan
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // PRIVATE METHODS 

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<void> _removeUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }
}