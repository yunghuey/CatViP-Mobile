import 'dart:convert';

PostComment postTypeFromJson(String str) => PostComment.fromJson(jsonDecode(str));

String postTypeToJson(PostComment data) => json.encode(data.toJson());

// 1-Create the class
class PostComment {

  PostComment({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.username,
    required this.profileImage,
    required this.error,
  });

  // 2- Create the protperties
  int? id;
  String? description;
  String? dateTime;
  String? username;
  String? profileImage;
  String? error;


  factory PostComment.fromJson(Map<String, dynamic> json) {
    print("JSON Data: $json");

    return PostComment(
      error: json["error"],
      id: json["id"],
      description: json["description"],
      dateTime: json["dateTime"],
      username: json["username"],
      profileImage: json["profileImage"],
    );

  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "id": id,
    "description": description,
    "dateTime": dateTime,
    "username": username,
  };

  PostComment.withError(String message){
    error = message;
  }

}