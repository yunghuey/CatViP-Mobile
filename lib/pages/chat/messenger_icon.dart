import 'package:CatViP/bloc/chat/chat_bloc.dart';
import 'package:CatViP/bloc/chat/chat_event.dart';
import 'package:CatViP/bloc/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class MessengerIcon extends StatefulWidget {
  const MessengerIcon({super.key});

  @override
  State<MessengerIcon> createState() => _MessengerIconState();
}

class _MessengerIconState extends State<MessengerIcon> {
  late int msgCount;
  late ChatBloc chatBloc;

  @override
  void initState() {
    // chatBloc = BlocProvider.of<ChatBloc>(context);
    // chatBloc.add(UnreadInitEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
    BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state){
        if (state is UnreadChatState){
           return Badge.Badge(
             badgeContent: Text(state.num.toString(), style: TextStyle(color: Colors.white)),
             badgeStyle: Badge.BadgeStyle(
               shape: Badge.BadgeShape.circle,
               badgeColor: HexColor("#3c1e08"),
             ),
             child: Icon(
               Icons.messenger_outline,
               color: HexColor("#3c1e08"),
             ),
           );
        }
        else{
          return  Icon(
            Icons.messenger_outline,
            color: HexColor("#3c1e08"),
          );
        }
      },
    );
  }
}
