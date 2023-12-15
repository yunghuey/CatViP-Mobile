import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';

import 'package:CatViP/bloc/chat/chat_bloc.dart';
import 'package:CatViP/bloc/chat/chat_event.dart';
import 'package:CatViP/bloc/chat/chat_state.dart';
import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/chat/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleChatView extends StatefulWidget {
  final ChatListModel user;
  const SingleChatView({ required this.user, Key? key}): super(key: key);

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  late ChatBloc chatBloc;
  late List<MessageModel> messagelist;
  late HubConnection hubConnection;
  TextEditingController msgController = TextEditingController();
  String? username = "";
  int isInitialized = 0;
  String _receivedMessage = "";
  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(SingleUserButtonPressed(userid: widget.user.userid));

    hubConnection = HubConnectionBuilder()
        .withUrl('http://10.131.78.121:7015/chathub')
        .build();
    _setConnection();
    super.initState();
  }

  Future<String?> getCurrentUsername() async{
    var pref = await SharedPreferences.getInstance();
    return pref.getString("username");
  }

  Future<void> _setConnection() async {
    username = await getCurrentUsername();
    hubConnection.onclose((error) => print('Connection Closed'));
    hubConnection.on('ReceiveMessageFrom${widget.user.username}To${username}',
        _handleIncomingMessage);
    _startConnection();
  }

  Future<void> _startConnection() async {
    await hubConnection.start();
  }

  void _handleIncomingMessage(List<dynamic>? arguments) {
    if (arguments != null && arguments.length >= 1) {
      String message = arguments[0];

      setState(() {
        MessageModel newmessage = MessageModel(
          message: message,
          dateTime: DateTime.now().toString(),
          isCurrentUserSent: false,
        );
        // messagelist.add(newmessage);
        print(messagelist);
        print("received message: ${_receivedMessage}" );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children:[
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: widget.user.profileImage != ""
                    ? MemoryImage(base64Decode(widget.user.profileImage!))  as ImageProvider<Object>
                    : AssetImage('assets/profileimage.png'),
              ),
              Expanded(
                child: ListTile(
                  title: Text(widget.user.fullname, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state){
          if (state is ChatLoadingState){
            return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
          }
          else if (state is MessageListEmpty){
            return Center(child: Container(child: Text(state.message),),);
          }
          else if (state is MessageListLoaded){
            messagelist = state.messagelist.reversed.toList();
            chatBloc.add(MessageInitEvent());
            return displayChat();
          } else if (state is MessageInitState){
            return displayChat();
          }
          return Center(child: Text("Error in getting chat"));
        },
      ),
    );
  }

  Widget bottomTextBox(){
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0, top: 5.0),
      color: Colors.grey.shade300,
      child: TextField(
        controller: msgController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          hintText: "Type your message here...",
          focusColor: HexColor("#3c1e08"),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
          suffixIcon: IconButton(
              onPressed: (){
                MessageModel newmsg = MessageModel(
                    message: msgController.text,
                    isCurrentUserSent: true,
                    dateTime: DateTime.now().toString()
                );
                setState(() {
                  messagelist.add(newmsg);
                  _sendPrivateMessage();
                });
                msgController.text = "";
              },
              icon: const Icon(Icons.send),
          ),
          suffixIconColor: HexColor("#3c1e08"),
        ),
      ),
    );
  }

  Widget messageListView(){
    return Expanded(
      child: GroupedListView<MessageModel, DateTime>(
        reverse: true,
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        padding: const EdgeInsets.all(8),
        elements: messagelist,
        groupBy: (message) => DateTime(
          message.date.year,
          message.date.month,
          message.date.day,
        ),
        groupHeaderBuilder: (MessageModel message) => SizedBox(
          height: 40,
          child: Center(
            child: Card(
              color: HexColor("#3c1e08"),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat.yMMMd().format(message.date),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (context, MessageModel message) => Align(
          alignment: message.isCurrentUserSent ? Alignment.topRight : Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message.message,
                  style: TextStyle(fontSize: 15),)
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget displayChat(){
    return Column(
      children: [
        messageListView(),
        bottomTextBox(),
      ],
    );
  }

  Future<void> _sendPrivateMessage() async {
    String sendUser = username ?? "";
    String receiveUser = widget.user.username;
    String message = msgController.text;
    await hubConnection.invoke('SendPrivateMessage',
        args: <Object>[sendUser, receiveUser, message]);
  }
}
