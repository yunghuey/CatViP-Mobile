class ChatListModel{
  int userid;
  String username;
  String fullname;
  String? profileImage;
  String latestMsg;

  ChatListModel({
    required this.userid,
    required this.username,
    required this.fullname,
    this.profileImage,
    required this.latestMsg,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json){
    return ChatListModel(
      userid: json['id'],
      username: json['username'],
      fullname: json['fullName'],
      profileImage: json['profileImage'] ?? "",
      latestMsg: json['lastestChat'],
    );
  }
}