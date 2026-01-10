import 'dart:convert';

class EducationModel {
    final bool success;
    final Data? data;

    EducationModel({
        required this.success,
        this.data,
    });

    factory EducationModel.fromJson(String str) => EducationModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EducationModel.fromMap(Map<String, dynamic> json) => EducationModel(
        success: json["success"] ?? false,
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "data": data?.toMap(),
    };
}

class Data {
    final int currentPage;
    final List<EducationalContentModel> data;
    final String firstPageUrl;
    final int? from;
    final int lastPage;
    final String lastPageUrl;
    final List<Link> links;
    final String? nextPageUrl;
    final String path;
    final int perPage;
    final String? prevPageUrl;
    final int? to;
    final int total;

    Data({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        this.nextPageUrl,
        required this.path,
        required this.perPage,
        this.prevPageUrl,
        this.to,
        required this.total,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"] ?? 1,
        data: json["data"] == null 
            ? [] 
            : List<EducationalContentModel>.from(json["data"].map((x) => EducationalContentModel.fromMap(x))),
        firstPageUrl: json["first_page_url"] ?? "",
        from: json["from"],
        lastPage: json["last_page"] ?? 1,
        lastPageUrl: json["last_page_url"] ?? "",
        links: json["links"] == null 
            ? [] 
            : List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 10,
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"] ?? 0,
    );

    Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class EducationalContentModel {
    final int id;
    final String title;
    final String content;
    final String category;
    final String? image;
    final int? createdByAdminId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    EducationalContentModel({
        required this.id,
        required this.title,
        required this.content,
        required this.category,
        this.image,
        this.createdByAdminId,
        this.createdAt,
        this.updatedAt,
    });

    factory EducationalContentModel.fromMap(Map<String, dynamic> json) => EducationalContentModel(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        content: json["content"] ?? "",
        category: json["category"] ?? "",
        image: json["image"],
        createdByAdminId: json["created_by_admin_id"],
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "category": category,
        "image": image,
        "created_by_admin_id": createdByAdminId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Link {
    final String? url;
    final String label;
    final bool active;

    Link({
        this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromMap(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"] ?? "",
        active: json["active"] ?? false,
    );

    Map<String, dynamic> toMap() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
