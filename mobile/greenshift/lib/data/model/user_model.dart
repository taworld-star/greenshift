import 'dart:convert';

class UserResponse {
    final bool success;
    final User user;

    UserResponse({
        required this.success,
        required this.user,
    });

    UserResponse copyWith({
        bool? success,
        User? user,
    }) => 
        UserResponse(
            success: success ?? this.success,
            user: user ?? this.user,
        );

    factory UserResponse.fromJson(String str) => UserResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserResponse.fromMap(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        user: User.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "user": user.toMap(),
    };
}

class User {
    final int id;
    final String name;
    final String email;
    final String role;
    final int totalScans;
    final int points;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.role,
        required this.totalScans,
        required this.points,
    });

    User copyWith({
        int? id,
        String? name,
        String? email,
        String? role,
        int? totalScans,
        int? points,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            role: role ?? this.role,
            totalScans: totalScans ?? this.totalScans,
            points: points ?? this.points,
        );

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Tanpa nama" ,
        email: json["email"] ?? "",
        role: json["role"] ?? "User",
        totalScans: int.tryParse(json["total_scans"].toString()) ?? 0,
        points: int.tryParse(json["points"].toString()) ?? 0,
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "total_scans": totalScans,
        "points": points,
    };
}
