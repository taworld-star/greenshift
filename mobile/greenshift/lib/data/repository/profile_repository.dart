import 'package:greenshift/data/service/httpservice.dart';
import 'package:greenshift/data/model/user_model.dart';

class ProfileRepository {
  final HttpService _httpService = HttpService();

  // Mengambil data user dari login
  Future<User?> getProfile() async {
    try {
      final response = await _httpService.get('/user');
      if (response.statusCode == 200) {
        final userResponse = UserResponse.fromJson(response.body);
        return userResponse.user;
      }
      return null;
    } catch (e) {
      print("Error getProfile: $e");
      return null;
    }
  }
}
