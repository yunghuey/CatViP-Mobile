class MessageModel{
  String message;
  String dateTime;
  bool isCurrentUserSent;
  DateTime get date => DateTime.parse(dateTime);

  MessageModel({
    required this.message,
    required this.dateTime,
    required this.isCurrentUserSent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json){
    return MessageModel(
      message: json["message"],
      dateTime: json["dateTime"],
      isCurrentUserSent: json["isCurrentUserSent"],
    );
  }
}