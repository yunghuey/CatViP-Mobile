import 'dart:convert';

CaseReportComment postTypeFromJson(String str) => CaseReportComment.fromJson(jsonDecode(str));

// 1-Create the class
class CaseReportComment {

  CaseReportComment({
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


  factory CaseReportComment.fromJson(Map<String, dynamic> json) {
    print("JSON Data: $json");

    return CaseReportComment(
      error: json["error"],
      id: json["id"],
      description: json["description"],
      dateTime: json["dateTime"],
      username: json["username"],
      profileImage: json["profileImage"],
    );

  }

  CaseReportComment.withError(String message){
    error = message;
  }

}
