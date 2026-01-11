import 'dart:io';

import 'package:greenshift/data/model/scan_model.dart';
import 'package:greenshift/data/service/httpservice.dart';

class ScanRepository {
  final HttpService _httpService = HttpService();

  //Scan Image (Mengirim gambar ke ai python service)
  Future<Map<String, dynamic>?> scanImage(File image) async {
    try{
      final aiResponse = await _httpService.postWithFile(
        '/predict',
        {},
        image,
        'file',
        isPython: true,
      );

      if (aiResponse.statusCode == 200) {
        await _httpService.postWithFile(
          '/scan',
          {'result' : aiResponse.body},
          image,
          'image',
        );
        return {'succes': true, 'result':aiResponse.body};
      }
      return null;
    } catch (e) {
      print("Error scanImage: $e");
      return null;
    }
  }

  //
  Future<ScanModel?> getDashboard() async {
    try {
      final response = await _httpService.get('/scan/dashboard');
      if (response.statusCode == 200) {
        return ScanModel.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Error getDashboard: $e");
      return null;
    }
  }
}

