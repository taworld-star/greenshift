import 'dart:convert';
import 'dart:io';

import 'package:greenshift/data/model/educational_content_model.dart';
import 'package:greenshift/data/service/httpservice.dart';

class EducationRepository {
  final HttpService _httpService = HttpService();

  //Mengambil semua konten edukasi
  Future<EducationModel?> getAll({String? category, int page = 1}) async {
    try{
      String endpoint = 'content?page=$page';
      if (category != null) endpoint += '&category=$category';
      final response = await _httpService.get(endpoint);

      if (response.statusCode == 200) {
        return EducationModel.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Error getAll: $e");
      return null;
    }
  }

  //Mengambil detail 1 konten
  Future<EducationalContentModel?> getById(int id) async {
    try {
      final response = await _httpService.get('/content/$id');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return EducationalContentModel.fromMap(jsonData['data']);
      }
      return null;
    } catch (e) {
      print("Error getById: $e");
      return null;
    }
  }

  //Menambah konten baru (role admin)
  Future<bool> create({
    required String title,
    required String content,
    required String category,
    File? image,
  }) async {
    try {
      final response = await _httpService.postWithFile(
        '/content', 
        {'title' : title,
         'content': content,
         'category': category},
         image, 'image',
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Error create: $e");
      return false;
    }
  }

  //Menghapus konten (role admin)
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
