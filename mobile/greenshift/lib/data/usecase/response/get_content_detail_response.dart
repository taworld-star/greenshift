import 'dart:convert';
import 'package:greenshift/data/model/educational_content_model.dart';

class GetContentDetailResponse {
  final bool success;
  final String? message;
  final EducationalContentModel? data;  // 1 konten saja (bukan List)

  GetContentDetailResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory GetContentDetailResponse.fromMap(Map<String, dynamic> json) =>
      GetContentDetailResponse(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"] == null ? null : EducationalContentModel.fromMap(json["data"]),
      );

  factory GetContentDetailResponse.fromJson(String str) =>
      GetContentDetailResponse.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data?.toMap(),
  };

  String toJson() => json.encode(toMap());
}