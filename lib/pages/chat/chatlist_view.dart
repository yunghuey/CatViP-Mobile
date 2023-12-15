import 'dart:convert';
import 'package:CatViP/bloc/chat/chat_bloc.dart';
import 'package:CatViP/bloc/chat/chat_event.dart';
import 'package:CatViP/bloc/chat/chat_state.dart';
import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/pages/chat/singlechat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late ChatBloc chatBloc;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(ChatListLoadEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat", style: TextStyle(color:  HexColor("#3c1e08"))),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state){
          if (state is ChatLoadingState){
            return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
          } else if (state is ChatListLoaded){
            print("chat list inside loaded state");
            return resultList(state.chatlist);
          } else if (state is ChatListEmpty){
            return Container(
              child: Text(state.message),
            );
          }
          return Container(
            child: Text("test") ,
          );
        },
      ),
    );
  }

  Widget resultList(List<ChatListModel> chatlist){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: chatlist.length,
        itemBuilder: (context, index){
          var chat = chatlist[index];
          return InkWell(
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => SingleChatView(user:chat))).then((value) => {    chatBloc.add(ChatListLoadEvent())
              } );
            //   navigate to single user chat
            },
            child: Card(
              elevation: 0,
              color: HexColor("#ecd9c9"),
              margin: const EdgeInsets.only(top: 5.0, bottom: 13.0, left: 5.0),
              child: Row(
                children:[
                  CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: chat.profileImage != ""
                      ? MemoryImage(base64Decode(chat.profileImage!))  as ImageProvider<Object>
                      : AssetImage('assets/profileimage.png'),
                ),
                  Expanded(
                    child: ListTile(
                      title: Text(chat.fullname, style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(chat.latestMsg),
                    ),
                  ),
              ],
            ),

            ),
          );

        }
      ),
    );
  }
}
