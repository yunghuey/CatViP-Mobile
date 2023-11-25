import 'dart:convert';

PostType postTypeFromJson(String str) => PostType.fromJson(jsonDecode(str));

String postTypeToJson(PostType data) => json.encode(data.toJson());

// 1-Create the class
class PostType {

  PostType({
    required this.id,
    required this.name,
    required this.error,
  });

  // 2- Create the protperties
  int? id;
  String? name;
  String? error;

  factory PostType.fromJson(Map<String, dynamic> json) {
    print("JSON Data: $json");

    return PostType(
      error: json["error"],
      id: json["id"],
      name: json["name"],
    );

  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "id": id,
    "name": name,
  };

  PostType.withError(String message){
    error = message;
  }

}