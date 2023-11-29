class ExpertApplyModel{
  int id;
  String description;
  String document;
  String? rejectedReason;
  String applyDateTime;
  String status;

  ExpertApplyModel({
    required this.id,
    required this.description,
    required this.document,
    required this.applyDateTime,
    required this.status,
    this.rejectedReason
  });

  factory ExpertApplyModel.fromJson(Map<String, dynamic> json){
    return ExpertApplyModel(
      id: json["id"],
      description: json["description"],
      document: json["documentation"],
      applyDateTime: json["dateTime"],
      status: json["status"],
      rejectedReason: json["rejectedReason"] ?? ""
    );
  }
}