import 'dart:convert';
import 'package:greenshift/data/model/educational_content_model.dart';

class GetContentResponse {
  final bool success;
  final String? message;
  final List<EducationalContentModel> data;       
  final int currentPage;
  final int lastPage;
  final int total;

  GetContentResponse({
    required this.success,
    this.message,
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory GetContentResponse.fromMap(Map<String, dynamic> json) {
    final paginatedData = json["data"] ?? {};
    return GetContentResponse(
      success: json["success"] ?? false,
      message: json["message"],
      data: paginatedData["data"] == null
          ? []
          : List<EducationalContentModel>.from(
              paginatedData["data"].map((x) => EducationalContentModel.fromMap(x)),
            ),
      currentPage: paginatedData["current_page"] ?? 1,
      lastPage: paginatedData["last_page"] ?? 1,
      total: paginatedData["total"] ?? 0,
    );
  }

  factory GetContentResponse.fromJson(String str) =>
      GetContentResponse.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "current_page": currentPage,
    "last_page": lastPage,
    "total": total,
  };

  String toJson() => json.encode(toMap());
}