import 'package:CatViP/bloc/chat/chat_event.dart';
import 'package:CatViP/bloc/chat/chat_state.dart';
import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/chat/MessageModel.dart';
import 'package:CatViP/repository/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatRepository repo;
  ChatBloc(ChatState initialState, this.repo):super(initialState){
    on<ChatListInitEvent>((event, state){
      emit(ChatInitState());
    });

    on<ChatListLoadEvent>((event, state) async {
      emit(ChatLoadingState());
      List<ChatListModel>? hasList = await repo.getAllChatList();
      if (hasList.length >0){
        emit(ChatListLoaded(chatlist: hasList));
      } else{
        emit(ChatListEmpty(message: "No message yet"));
      }
    });

    on<SingleUserButtonPressed>((event, emit) async {
      emit(ChatLoadingState());
      List<MessageModel>? hasList = await repo.getAllMessages(event.userid);
      if(hasList.length > 0){
        emit(MessageListLoaded(messagelist: hasList));
      } else {
        emit(MessageListEmpty(message: "No chats yet"));
      }
    });

    on<MessageInitEvent>((event, emit){
      emit(MessageInitState());
    });
  }
}