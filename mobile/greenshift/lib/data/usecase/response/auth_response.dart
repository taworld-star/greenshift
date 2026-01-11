import 'dart:convert';

import 'package:greenshift/data/model/user_model.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? token;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
    success: json["success"] ?? false,
    message: json["message"],
    user: json["user"] == null ? null : User.fromMap(json["user"]),
    token: json["token"],
  );

  factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
    "success" : success,
    "message" : message,
    "user" :user?.toMap(),
    "token" : token,
  };

  String toJson() => json.encode(toMap());

}