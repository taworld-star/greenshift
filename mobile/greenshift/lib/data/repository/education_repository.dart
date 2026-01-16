import 'package:greenshift/data/usecase/request/education_request.dart';
import 'package:greenshift/data/usecase/response/get_content_response.dart';
import 'package:greenshift/data/usecase/response/get_content_detail_response.dart';
import 'package:greenshift/data/service/httpservice.dart';

class EducationRepository {
  final HttpService _httpService = HttpService();

  /// Mengambil semua konten edukasi - Menggunakan GetContentResponse
  Future<GetContentResponse?> getAll({String? category, int page = 1}) async {
    try {
      String endpoint = '/content?page=$page';
      if (category != null) endpoint += '&category=$category';
      
      final response = await _httpService.get(endpoint);

      if (response.statusCode == 200) {
        return GetContentResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Error getAll: $e");
      return null;
    }
  }

  /// Mengambil detail 1 konten - Menggunakan GetContentDetailResponse
  Future<GetContentDetailResponse?> getById(int id) async {
    try {
      final response = await _httpService.get('/content/$id');
      if (response.statusCode == 200) {
        return GetContentDetailResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Error getById: $e");
      return null;
    }
  }

  /// Menambah konten baru (role admin) - Menggunakan EducationRequest
  Future<bool> create(EducationRequest request) async {
    try {
      final response = await _httpService.postWithFile(
        '/content', 
        request.toFields(),
        request.image, 
        'image',
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Error create: $e");
      return false;
    }
  }

  /// Mengupdate konten (role admin) - Menggunakan EducationRequest
  Future<bool> update(int id, EducationRequest request) async {
    try {
      final fields = request.toFields();
      fields['_method'] = 'PUT'; // Laravel method spoofing
      
      final response = await _httpService.postWithFile(
        '/content/$id',
        fields,
        request.image,
        'image',
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error update: $e");
      return false;
    }
  }

  /// Menghapus konten (role admin)
  Future<bool> delete(int id) async {
    try {
      final response = await _httpService.delete('/content/$id');
      return response.statusCode == 200;
    } catch (e) {
      print("Error delete: $e");
      return false;
    }
  }
}
