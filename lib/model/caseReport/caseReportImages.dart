import 'dart:convert';

class CaseReportImage {

  CaseReportImage({
    required this.images,
    required this.isBloodyContent,
  });

  final String images;
  bool? isBloodyContent;

  factory CaseReportImage.fromJson(Map<String, dynamic> json) {

    //List<String> images = List<String>.from(json["image"] ?? []);

    return CaseReportImage(
      images: json["image"],
      isBloodyContent: json["isBloodyContent"],
    );
  }

  Map<String, dynamic> toJson() => {
    "image": images,
    "isBloodyContent": isBloodyContent,
  };

}