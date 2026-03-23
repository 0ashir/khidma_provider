class BlogDetails {
  BlogDetails({
    required this.success,
    required this.data,
  });

  final bool? success;
  final Data? data;

  factory BlogDetails.fromJson(Map<String, dynamic> json){
    return BlogDetails(
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.content,
    required this.createdBy,
    required this.categories,
    required this.tags,
    required this.media,
  });

  final int? id;
  final String? title;
  final String? description;
  final dynamic createdAt;
  final String? content;
  final CreatedBy? createdBy;
  final List<Category> categories;
  final List<Category> tags;
  final List<Media> media;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      content: json["content"],
      createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
      tags: json["tags"] == null ? [] : List<Category>.from(json["tags"]!.map((x) => Category.fromJson(x))),
      media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    );
  }

}

class Category {
  Category({
    required this.id,
    required this.title,
  });

  final int? id;
  final String? title;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      title: json["title"],
    );
  }

}

class CreatedBy {
  CreatedBy({
    required this.name,
  });

  final String? name;

  factory CreatedBy.fromJson(Map<String, dynamic> json){
    return CreatedBy(
      name: json["name"],
    );
  }

}

class Media {
  Media({
    required this.id,
    required this.collectionName,
    required this.originalUrl,
  });

  final int? id;
  final String? collectionName;
  final String? originalUrl;

  factory Media.fromJson(Map<String, dynamic> json){
    return Media(
      id: json["id"],
      collectionName: json["collection_name"],
      originalUrl: json["original_url"],
    );
  }

}
