import 'dart:convert';
import 'package:greenshift/data/model/scan_model.dart';

class GetDashboardResponse {
  final bool success;
  final String? message;
  final DashboardData? data;

  GetDashboardResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory GetDashboardResponse.fromMap(Map<String, dynamic> json) =>
      GetDashboardResponse(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"] == null ? null : DashboardData.fromMap(json["data"]),
      );

  factory GetDashboardResponse.fromJson(String str) =>
      GetDashboardResponse.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data?.toMap(),
  };

  String toJson() => json.encode(toMap());
}