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
        emit(ChatListEmpty(message: "You have not send a message before. Find a friend to chat today!"));
      }
    });

    // comfirm got chat because is from message list
    on<SingleUserButtonPressed>((event, emit) async {
      emit(ChatLoadingState());
      List<MessageModel>? hasList = await repo.getAllMessages(event.userid);
      if(hasList.length > 0){
        emit(MessageListLoaded(messagelist: hasList));
      } else {
        emit(MessageListEmpty(message: "Error: Message list unable to load"));
      }
    });

    on<MessageInitEvent>((event, emit){
      emit(MessageInitState());
    });

    on<CheckMessageHistoryEvent>((event, emit) async {
      emit(ChatLoadingState());
      List<MessageModel>? hasList = await repo.getAllMessages(event.userid);
      if(hasList.length > 0) {
        emit(MessageListLoaded(messagelist: hasList));
      } else{
        emit(CreateNewChatState());
      }
    });

    on<HandleUnreadEvent>((event, emit) async {
      bool isUpdated = await repo.updateLastSeen(event.userid);
      if (isUpdated){
        emit(SettledUnreadState());
        emit(ChatLoadingState());
        List<ChatListModel>? hasList = await repo.getAllChatList();
        if (hasList.length >0){
          emit(ChatListLoaded(chatlist: hasList));
        } else{
          emit(ChatListEmpty(message: "You have not send a message before. Find a friend to chat today!"));
        }
      }
      else {
        emit(UnsettledUnreadState());
      }
    });

    on<UnreadInitEvent>((event, emit) async{
      int num = await repo.getUnreadChatCount();
      if (num == 0){
        emit(EmptyUnreadChatState());
      } else {
        emit(UnreadChatState(num: num));
      }
    });
  }
}