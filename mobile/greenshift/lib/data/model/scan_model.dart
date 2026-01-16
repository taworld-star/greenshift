import 'dart:convert';

class ScanModel {
    final bool success;
    final DashboardData? data; // Bisa null kalau server error

    ScanModel({
        required this.success,
        required this.data,
    });

    ScanModel copyWith({
        bool? success,
        DashboardData? data,
    }) => 
        ScanModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        success: json["success"] ?? false,
        // Cek "data" apakah ada isinya
        data: json["data"] == null ? null : DashboardData.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "data": data?.toMap(),
    };
}


class DashboardData {
    final String userName;
    final int greenScore;
    final Stats stats;
    final List<RecentItem> recentItems;

    DashboardData({
        required this.userName,
        required this.greenScore,
        required this.stats,
        required this.recentItems,
    });

    factory DashboardData.fromMap(Map<String, dynamic> json) => DashboardData(
        userName: json["user_name"] ?? "User",
        greenScore: int.tryParse(json["green_score"].toString()) ?? 0,
        stats: Stats.fromMap(json["stats"] ?? {}),
        recentItems: json["recent_items"] == null 
            ? [] 
            : List<RecentItem>.from(json["recent_items"].map((x) => RecentItem.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "user_name": userName,
        "green_score": greenScore,
        "stats": stats.toMap(),
        "recent_items": List<dynamic>.from(recentItems.map((x) => x.toMap())),
    };
}

class RecentItem {
    final String id;
    final String category;
    final String label;
    final String date;
    final String confidence;
    final String image;

    RecentItem({
        required this.id,
        required this.category,
        required this.label,
        required this.date,
        required this.confidence,
        required this.image,
    });

    factory RecentItem.fromMap(Map<String, dynamic> json) => RecentItem(
        id: json["id"]?.toString() ?? "",
        category: json["category"] ?? "-",
        label: json["label"] ?? "-",
        date: json["date"] ?? "",
        confidence: json["confidence"]?.toString() ?? "0",
        image: json["image"] ?? "",
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
        "label": label,
        "date": date,
        "confidence": confidence,
        "image": image,
    };
}

class Stats {
    final int organik;
    final int daurUlang;
    final int berbahaya;

    Stats({
        required this.organik,
        required this.daurUlang,
        required this.berbahaya,
    });

    factory Stats.fromMap(Map<String, dynamic> json) => Stats(
        organik: int.tryParse(json["organik"].toString()) ?? 0,
        daurUlang: int.tryParse(json["daur_ulang"].toString()) ?? 0,
        berbahaya: int.tryParse(json["berbahaya"].toString()) ?? 0,
    );

    Map<String, dynamic> toMap() => {
        "organik": organik,
        "daur_ulang": daurUlang,
        "berbahaya": berbahaya,
    };
}