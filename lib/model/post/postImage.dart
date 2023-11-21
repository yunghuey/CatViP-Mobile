import 'dart:convert';

class PostImage {

  PostImage({
    required this.image,
    required this.isBloodyContent,
  });

  String? image;
  bool? isBloodyContent;

    factory PostImage.fromJson(Map<String, dynamic> json) {
      return PostImage(
        image: json["image"],
        isBloodyContent: json["isBloodyContent"],
      );
    }

  Map<String, dynamic> toJson() => {
    "image": image,
    "isBloodyContent": isBloodyContent,
  };

}