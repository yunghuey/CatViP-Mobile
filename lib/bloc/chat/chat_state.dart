import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/chat/MessageModel.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable{
  @override
  List<Object> get props => [];
}

class ChatInitState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatListLoaded extends ChatState {
  final List<ChatListModel> chatlist;
  ChatListLoaded({ required this.chatlist });
}

class ChatListEmpty extends ChatState {
  final String message;
  ChatListEmpty({required this.message});
}

class MessageListLoaded extends ChatState {
  final List<MessageModel> messagelist;
  MessageListLoaded({ required this.messagelist });
}

class MessageListEmpty extends ChatState{
  final String message;
  MessageListEmpty({ required this.message });
}

class MessageInitState extends ChatState{}