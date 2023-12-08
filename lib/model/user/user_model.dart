import 'dart:convert';

class UserModel {
  String username;
  String fullname;
  String email;
  bool gender;
  String dateOfBirth;
  String? address;
  String? profileImage;
  double? longitude;
  double? latitude;
  bool? isShownOnMap;
  int? follower;
  int? following;
  bool? isExpert;
  int? expertTips;
  int? validToApply;

  UserModel({
    required this.username,
    required this.fullname,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    this.address,
    this.profileImage,
    this.longitude,
    this.latitude,
    this.isShownOnMap,
    this.follower,
    this.following,
    this.isExpert,
    this.expertTips,
    this.validToApply,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"],
      fullname: json["fullName"],
      email: json["email"],
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"],
      address: json["address"],
      profileImage: json["profileImage"] ?? "", // Use an empty string if it's null
      longitude: json["longitude"],
      latitude: json["latitude"],
      isShownOnMap: json["isShownOnMap"],
      follower: json["follwer"],
      following: json["following"],
      isExpert: json["isExpert"],
      expertTips: json["expertTips"],
    );
  }
}
