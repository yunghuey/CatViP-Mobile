import 'dart:convert';
import 'package:CatViP/bloc/search/user/searchuser_bloc.dart';
import 'package:CatViP/bloc/search/user/searchuser_event.dart';
import 'package:CatViP/bloc/search/user/searchuser_state.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/pages/search/searchuser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchUserView extends StatefulWidget {
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  TextEditingController nameController = TextEditingController();
  List<UserModel> userlist = [];
  late SearchUserBloc searchBloc;

  @override
  void initState() {
    // TODO: implement initState
    searchBloc = BlocProvider.of<SearchUserBloc>(context);
    searchBloc.add(SearchInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            margin: EdgeInsets.only(top: 15),
            color: HexColor("#D0D4CA"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nameField(),
                IconButton(onPressed: (){
                  if (nameController.text.length > 0){
                    searchBloc.add(SearchUserPressed(name: nameController.text.trim()));
                  }
                }, icon: Icon(Icons.search)),
              ],
            ),
          ),
        ),
      ),
      body:
      BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, state){
          if (state is SearchUserEmptyState){
            return Container(
              margin: const EdgeInsets.all(18.0),
              padding: const EdgeInsets.all(5.0),
              child: const Text("This user does not exists",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            );
          }
          else if (state is SearchUserLoadingState){
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          }
          else if (state is SearchUserLoadedState){
            print("get user ${state.searchList}");
            userlist = state.searchList;
            return _resultList();
          }
          return Container();
        }
      ),
    );
  }

  Widget nameField(){
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 270,
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: "Search",
          focusColor: HexColor("#3c1e08"),
        ),
        onChanged: (text){
          print("text: ${text}");
          if (text.length > 0) {
            searchBloc.add(SearchUserPressed(name: text.trim()));
          }
        },
      ),
    );
  }

  Widget _resultList(){
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: ListView.builder(
        itemCount: userlist.length,
        itemBuilder: (context, index){
          UserModel user = userlist[index];
          return InkWell(
            onTap: (){
              int userid = user.id!;
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchView(userid: userid)));
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: user.profileImage != ""
                        ? MemoryImage(base64Decode(user.profileImage!))  as ImageProvider<Object>
                        : AssetImage('assets/profileimage.png'),
                  ),
                  Expanded(
                    child: ListTile(
                      title: ListTile(
                        title: Text(user.fullname),
                        subtitle: Text(user.username),
                      )
                    ),
                  )
                ],
              )
            ),
          );
        }
      ),
    );
  }
}