class CatModel{
  int id;
  String name;
  String desc;
  String dob;
  String? datetimecreated;
  bool gender;
  String profileImage;

  CatModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.dob,
    this.datetimecreated,
    required this.gender,
    required this.profileImage
  });

  factory CatModel.fromJson(Map<String, dynamic> json){
    return CatModel(
      id: json["id"],
      name: json["name"],
      desc: json["description"],
      dob: json["dateOfBirth"],
      datetimecreated: json["dateTimeCreated"],
      gender: json["gender"],
      profileImage: json["profileImage"]
    );
  }
}