import 'package:greenshift/data/usecase/request/scan_request.dart';
import 'package:greenshift/data/usecase/response/get_scan_response.dart';
import 'package:greenshift/data/usecase/response/get_dashboard_response.dart';
import 'package:greenshift/data/service/httpservice.dart';

class ScanRepository {
  final HttpService _httpService = HttpService();

  /// Scan Image - Mengirim gambar ke AI Python service
  /// Menggunakan ScanRequest dan GetScanResponse
  Future<GetScanResponse?> scanImage(ScanRequest request) async {
    try {
      // 1. Kirim gambar ke Python AI service
      final aiResponse = await _httpService.postWithFile(
        '/predict',
        {},
        request.image,
        'file',
        isPython: true,
      );

      if (aiResponse.statusCode == 200) {
        // Parse response dari AI
        final scanResponse = GetScanResponse.fromJson(aiResponse.body);
        
        // 2. Menyimpan hasil scan ke Laravel backend dengan format yang benar
        if (scanResponse.data != null) {
          final category = scanResponse.data!.category;
          final confidence = double.tryParse(scanResponse.data!.confidence) ?? 0;
          
          await _httpService.postWithFile(
            '/scan',
            {
              'classification_result': category,  // 'organik', 'anorganik', atau 'b3'
              'confidence': (confidence * 100).toString(),  // Convert to 0-100 scale
            },
            request.image,
            'image',
          );
        }
        
        // 3. Return response dari AI
        return scanResponse;
      }
      return null;
    } catch (e) {
      print("Error scanImage: $e");
      return null;
    }
  }

  /// Get Dashboard - Mengambil data dashboard user
  /// Menggunakan GetDashboardResponse
  Future<GetDashboardResponse?> getDashboard() async {
    try {
      final response = await _httpService.get('/scan/dashboard');
      if (response.statusCode == 200) {
        return GetDashboardResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Error getDashboard: $e");
      return null;
    }
  }
}
