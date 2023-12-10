import 'dart:convert';

import 'package:CatViP/bloc/cat/catprofile_bloc.dart';
import 'package:CatViP/bloc/cat/catprofile_event.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:CatViP/bloc/user/userprofile_bloc.dart';
import 'package:CatViP/bloc/user/userprofile_event.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:CatViP/pages/cat/catprofile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchView extends StatefulWidget {
  int userid;
  SearchView({ required this.userid, super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String btntext = "Follow";
  late int userid;
  late List<CatModel> cats;
  late List<Post> listPost;
  late UserModel user;
  late UserProfileBloc userBloc;
  late GetPostBloc postBloc;
  late CatProfileBloc catBloc;
  @override
  void initState() {
    // TODO: implement initState
    userid = widget.userid;
    userBloc = BlocProvider.of<UserProfileBloc>(context);
    userBloc.add(LoadSearchUserEvent(userid: userid));
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    catBloc.add(SearchReloadAllCatEvent(userID: userid));
    postBloc = BlocProvider.of<GetPostBloc>(context);
    postBloc.add(LoadSearchAllPost(userid: userid));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state){
            if (state is UserProfileLoadedState) {
              final username = state.user.username ?? "Search";
              return Text(
                username,
                style: Theme.of(context).textTheme.bodyLarge,
              );
            } else {
              return Text( "Search", style: Theme.of(context).textTheme.bodyLarge,);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state){
                if (state is UserProfileLoadingState){
                  return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
                } else if (state is UserProfileErrorState){
                  return Container(
                    margin: const EdgeInsets.all(18.0),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(state.message,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                    ),
                  );
                } else if (state is UserProfileLoadedState){
                  user = state.user;
                  return _userDetails();
                }
                return Container();
              },
            ),

            BlocBuilder<CatProfileBloc, CatProfileState>(
              builder: (context, state){
                if (state is CatProfileLoadingState) {
                  return Center(child: CircularProgressIndicator(color: HexColor("#3c1e08")));
                } else if (state is CatProfileLoadedState) {
                  cats = state.cats;
                  print("get cat in frontend");
                  return _getAllCats();
                } else {
                  return Container(child: const Text("No cats has been added yet", style: TextStyle(fontSize: 17),)); // Handle other cases
                }
                return Container();
              }
            ),
            BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state is GetPostLoading) {
                    return Center(
                        child: CircularProgressIndicator(color: HexColor("#3c1e08")));
                  }
                  else if (state is GetPostLoaded) {
                    listPost = state.postList;
                    _getAllPosts();
                  }
                  return Center(
                    child: Container(
                      child: Text("No post is created yet", style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ); // Handle other cases
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),

    );
  }

  Widget _profileImage(){
    return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape:BoxShape.circle,
          image: DecorationImage(
            image:
            user.profileImage != ""
                ? MemoryImage(base64Decode(user.profileImage!)) as ImageProvider<Object> :
            AssetImage('assets/profileimage.png'),
            fit: BoxFit.cover,
          ),
        )
    );
  }

  Widget _followers(){
    return Column(
      children: [
        Text(user.follower.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Followers"),
      ],
    );
  }

  Widget _following(){
    return Column(
      children: [
        Text(user.following.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Following"),
      ],
    );
  }

  Widget _tipsPost(){
    if (user.isExpert == true){
      return Column(
        children: [
          Text(user.expertTips.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          Text("Tips"),
        ],
      );
    } else {
      return Column();
    }
  }

  Widget _userDetails(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _profileImage(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _followers(),
                    _following(),
                    _tipsPost(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buttons(),
      ],
    );
  }

  Widget _buttons(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: (){
                   setState(() {
                     btntext = (btntext == "Follow") ? "Unfollow" : "Follow";
                   });

                  },
                  child: Text(btntext),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(color: HexColor("#3c1e08"), width: 1)),
                    backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                    foregroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: (){},
                  child: Text("Message"),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(color: HexColor("#3c1e08"), width: 1)),
                    backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                    foregroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                  ),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAllCats(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        height: 120,
        child: ListView.builder(
          itemCount:cats.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final cat = cats[index];
            return Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CatProfileView(currentcat: cats[index],fromOwner: false,)))
                              .then((value) {
                                  catBloc.add(SearchReloadAllCatEvent(userID: userid));
                                  postBloc = BlocProvider.of<GetPostBloc>(context);
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: HexColor("#3c1e08"),
                          radius: 40,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage: cats[index].profileImage != ""
                                ? MemoryImage(base64Decode(cats[index].profileImage))  as ImageProvider<Object>
                                : AssetImage('assets/profileimage.png'),
                          ),
                        ),
                      ),
                    ),
                    Text(cats[index].name),
                  ],
                ),
              ],
            );
          },

        ),
      ),
    );
  }

  Widget _getAllPosts(){
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1/1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index){
        final post = listPost[index];

        return GestureDetector(
          onTap: (){
            //   handle one image
            //   new page
            //   wait for wafir's code
            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(currentPost: post)));
          },
          child: Container(
            color: Colors.grey,
            child: post.postImages != null && post.postImages!.isNotEmpty ?
            Image(image: MemoryImage(base64Decode(post.postImages![0].image!)),fit: BoxFit.cover,) : Container(),
          ),
        );
      },
      itemCount: 10,
    );
  }


}
