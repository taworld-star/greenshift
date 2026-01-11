import 'dart:convert';

class GetScanResponse {
  final bool success;
  final String? message;
  final ScanResult? data;

  GetScanResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory GetScanResponse.fromMap(Map<String, dynamic> json) =>
      GetScanResponse(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"] == null ? null : ScanResult.fromMap(json["data"]),
      );

  factory GetScanResponse.fromJson(String str) =>
      GetScanResponse.fromMap(json.decode(str));
}

// Hasil klasifikasi AI
class ScanResult {
  final String label;       // "Contoh: Botol Plastik"
  final String category;    // "anorganik"
  final String confidence;  // "95.5"
  final String? tips;

  ScanResult({
    required this.label,
    required this.category,
    required this.confidence,
    this.tips,
  });

  factory ScanResult.fromMap(Map<String, dynamic> json) => ScanResult(
    label: json["label"] ?? "",
    category: json["category"] ?? "",
    confidence: json["confidence"]?.toString() ?? "0",
    tips: json["tips"],
  );

  Map<String, dynamic> toMap() => {
    "label": label,
    "category": category,
    "confidence": confidence,
    "tips": tips,
  };
}