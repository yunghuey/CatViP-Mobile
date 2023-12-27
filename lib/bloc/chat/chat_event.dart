import 'package:equatable/equatable.dart';

class ChatEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ChatListInitEvent extends ChatEvent{ }

class ChatListLoadEvent extends ChatEvent {}

class SingleUserButtonPressed extends ChatEvent {
  final int userid;
  SingleUserButtonPressed({ required this.userid});
}

class MessageInitEvent extends ChatEvent{}

class CheckMessageHistoryEvent extends ChatEvent {
  final int userid;
  CheckMessageHistoryEvent({required this.userid });
}

class HandleUnreadEvent extends ChatEvent {
  final int userid;
  HandleUnreadEvent({ required this.userid});
}

//unread message count
class UnreadInitEvent extends ChatEvent{}