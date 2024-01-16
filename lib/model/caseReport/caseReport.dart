import 'dart:convert';
import 'package:CatViP/model/caseReport/caseReportImages.dart';
import 'package:CatViP/model/post/postImage.dart';

CaseReport caseReportFromJson(String str) => CaseReport.fromJson(jsonDecode(str));

// 1-Create the class
class CaseReport {

  CaseReport({
    required this.id,
    required this.description,
    required this.username,
    required this.profileImage,
    required this.dateTime,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.catName,
    required this.caseReportImages,
    required this.error,
    required this.userId,
  });


  CaseReport.update({
    required this.id,
  });

  CaseReport.delete({
    required this.id,
  });

  // 2- Create the protperties
  int? id;
  String? description, error;
  String? profileImage, username;
  DateTime? dateTime;
  String? address;
  double? latitude;
  double? longitude;
  String? catName;
  int? userId;
  List<CaseReportImage>? caseReportImages;


  factory CaseReport.fromJson(Map<String, dynamic> json) {
    print("JSON Data: $json");
    List<CaseReportImage> images = [];
    if (json["caseReportImages"] != null) {
      for (var imageJson in json["caseReportImages"]) {
        images.add(
          CaseReportImage.fromJson(imageJson),
        );
      }
    }

    return CaseReport(

      error: json["error"],
      id: json["id"],
      username: json["username"],
      profileImage: json["profileImage"],
      description: json["description"],
      dateTime: DateTime.parse(json["dateTime"]),
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      catName: json["catName"],
      caseReportImages: images,
      userId: json["userId"],
    );
  }


  CaseReport.withError(String message){
    error = message;
  }

}