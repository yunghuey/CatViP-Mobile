class ChatListModel{
  int userid;
  String username;
  String fullname;
  String? profileImage;
  String latestMsg;
  int unreadMessage;

  ChatListModel({
    required this.userid,
    required this.username,
    required this.fullname,
    this.profileImage,
    required this.latestMsg,
    required this.unreadMessage,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json){
    return ChatListModel(
      userid: json['id'],
      username: json['username'],
      fullname: json['fullName'],
      profileImage: json['profileImage'] ?? "",
      latestMsg: json['lastestChat'],
      unreadMessage: json['unreadMessageCount'],
    );
  }
}