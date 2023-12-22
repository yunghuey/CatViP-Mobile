import 'dart:convert';
import 'package:CatViP/model/post/mentionedCat.dart';
import 'package:CatViP/model/post/postImage.dart';

Post postFromJson(String str) => Post.fromJson(jsonDecode(str));

String postToJson(Post data) => json.encode(data.toJson());

// 1-Create the class
class Post {

  Post({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.postTypeId,
    required this.likeCount,
    required this.currentUserAction,
    required this.commentCount,
    required this.dislikeCount,
    required this.postImages,
    required this.mentionedCats,
    required this.price,
    required this.adsUrl,
    required this.isCurrentUserPost,
    required this.isAds,
    required this.error,
  });

  Post.edit({
    required this.id,
    required this.description,
  });
  // 2- Create the protperties
  int? id;
  String? description, error;
  DateTime? dateTime;
  int? userId;
  String? username;
  String? profileImage;
  int? postTypeId;
  int? likeCount;
  int? currentUserAction;
  int? commentCount;
  int? dislikeCount;
  List<PostImage>? postImages;
  List<MentionedCat>? mentionedCats;
  double? price;
  String? adsUrl;
  bool? isCurrentUserPost;
  bool? isAds;

  factory Post.fromJson(Map<String, dynamic> json) {
    print("JSON Data: $json");
    List<PostImage> images = [];
    List<MentionedCat> cats = [];
    if (json["postImages"] != null) {
      for (var imageJson in json["postImages"]) {
        images.add(
          PostImage.fromJson(imageJson),
        );
      }
    }
    if (json["mentionedCats"] != null) {
      for (var catsJson in json["mentionedCats"]) {
        cats.add(
          MentionedCat.fromJson(catsJson),
        );
      }
    }

    return Post(
      error: json["error"],
      id: json["id"],  // id: 1
      description: json["description"],
      dateTime: json["dateTime"] != null ? DateTime.parse(json["dateTime"]) : null,
      userId: json["userId"],
      username: json["username"],
      profileImage: json["profileImage"],
      postTypeId: json["postTypeId"],
      likeCount: json["likeCount"],
      currentUserAction: json["currentUserAction"],
      commentCount: json["commentCount"],
      dislikeCount: json["dislikeCount"],
      postImages: images,
      mentionedCats: cats,
      price: json["price"],
      adsUrl: json["adsUrl"],
      isCurrentUserPost: json["isCurrentUserPost"],
      isAds: json["isAds"],
    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "id": id,
    "description": description,
    "dateTime": dateTime,
    "userId": userId,
    "postTypeId": postTypeId,
    "likeCount":  likeCount,
    "currentUserAction": currentUserAction,
    "commentCount": commentCount,
    "dislikeCount": dislikeCount,
    "postImages": postImages?.map((image) => image.toJson()).toList(),
  };

  Post.withError(String message){
    error = message;
  }

}