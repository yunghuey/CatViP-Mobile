import 'dart:convert';
import 'package:CatViP/bloc/cat/catprofile_bloc.dart';
import 'package:CatViP/bloc/cat/catprofile_event.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/bloc/post/DeletePost/deletePost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:CatViP/bloc/search/searchuser_bloc.dart';
import 'package:CatViP/bloc/search/searchuser_event.dart';
import 'package:CatViP/bloc/search/searchuser_state.dart';
import 'package:CatViP/bloc/user/relation_bloc.dart';
import 'package:CatViP/bloc/user/relation_event.dart';
import 'package:CatViP/bloc/user/relation_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/pages/cat/catprofile_view.dart';
import 'package:CatViP/pages/chat/singlechat_view.dart';
import 'package:CatViP/pages/post/comment.dart';
import 'package:CatViP/widgets/widgets.dart';
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
  late SearchUserBloc searchBloc;
  late GetPostBloc postBloc;
  late CatProfileBloc catBloc;
  late RelationBloc relBloc;
  late DeletePostBloc deleteBloc;
  final Widgets func = Widgets();
  bool isSet = false;

  @override
  void initState() {
    // TODO: implement initState
    userid = widget.userid;
    print("inside search user ${userid}");
    searchBloc = BlocProvider.of<SearchUserBloc>(context);
    searchBloc.add(SearchUserProfileEvent(userid: userid));
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    catBloc.add(SearchReloadAllCatEvent(userID: userid));
    postBloc = BlocProvider.of<GetPostBloc>(context);
    postBloc.add(LoadSearchAllPost(userid: userid));
    relBloc = BlocProvider.of<RelationBloc>(context);
    deleteBloc = BlocProvider.of<DeletePostBloc>(context);
    super.initState();
  }

  Future<void> refreshPage() async {
    searchBloc.add(SearchUserProfileEvent(userid: userid));
    catBloc.add(SearchReloadAllCatEvent(userID: userid));
    postBloc.add(LoadSearchAllPost(userid: userid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: BlocBuilder<SearchUserBloc, SearchUserState>(
            builder: (context, state) {
              if (state is SearchUserProfileLoaded) {
                final username = state.user.fullname ?? "Search";
                return Text(
                  username,
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              } else {
                return Text(
                  "Search",
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              }
            },
          ),
        ),
        body: BlocListener<RelationBloc, RelationState>(
          listener: (context, state) {
            if (state is UpdateFollowingState) {
              user.isFollowed = true;
            } else if (state is UpdateUnfollowingState) {
              user.isFollowed = false;
            } else if (state is RelationFailState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<SearchUserBloc, SearchUserState>(
            builder: (context, state) {
              if (state is SearchUserLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: HexColor("#3c1e08"),
                  ),
                );
              }
              else if (state is SearchUserProfileError) {
                return Container(
                  margin: const EdgeInsets.all(18.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    state.message,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                );
              }
              else if (state is SearchUserProfileLoaded) {
                print("Load");
                user = state.user;
                if (!isSet) {
                  btntext = user.isFollowed! ? "Following" : "Follow";
                  isSet = true;
                }
                return RefreshIndicator(
                  onRefresh: refreshPage,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _userDetails(),
                        BlocBuilder<CatProfileBloc, CatProfileState>(
                          builder: (context, state) {
                            if (state is CatProfileLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: HexColor("#3c1e08"),
                                ),
                              );
                            } else if (state is CatProfileLoadedState) {
                              cats = state.cats;
                              return _getAllCats();
                            } else {
                              return Container(
                                child: const Text(
                                  "No cats has been added yet",
                                  style: TextStyle(fontSize: 17),
                                ),
                              );
                            }
                          },
                        ),
                        BlocBuilder<GetPostBloc, GetPostState>(
                          builder: (context, state) {
                            if (state is GetPostLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: HexColor("#3c1e08"),
                                ),
                              );
                            } else if (state is GetPostLoaded) {
                              listPost = state.postList.reversed.toList();
                              return _getAllPosts();
                            } else {
                              return Center(
                                child: Container(
                                  child: Text(
                                    "No post is created yet",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              else{
                return RefreshIndicator(onRefresh: refreshPage,
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: HexColor("#3c1e08"),
                        ),
                        Text("Searching....."),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget _profileImage() {
    return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: user.profileImage != ""
                ? MemoryImage(base64Decode(user.profileImage!))
            as ImageProvider<Object>
                : AssetImage('assets/profileimage.png'),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _followers() {
    return Column(
      children: [
        Text(
          user.follower.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text("Followers"),
      ],
    );
  }

  Widget _following() {
    return Column(
      children: [
        Text(
          user.following.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text("Following"),
      ],
    );
  }

  Widget _tipsPost() {
    if (user.isExpert == true) {
      return Column(
        children: [
          Text(
            user.expertTips.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Text("Tips"),
        ],
      );
    } else {
      return Column();
    }
  }

  Widget _userDetails(){
    return RefreshIndicator(
      onRefresh: refreshPage,
      color: HexColor("#3c1e08"),
      child: Column(
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
      ),
    );
  }

  Widget _buttons(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        if (btntext == "Follow") {
                          relBloc.add(FollowButtonPressed(userID: userid));
                          setState(() {
                            user.follower = user.follower! + 1;
                            btntext =
                            (btntext == "Follow") ? "Following" : "Follow";
                          });
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Unfollow'),
                              content: Text(
                                  'Do you want to unfollow ${user.fullname}?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: HexColor('#3c1e08'))),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<HexColor>(
                                            (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return HexColor("#ecd9c9");
                                          return HexColor("#F2EFEA");
                                        }),
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0))),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    relBloc.add(
                                        UnfollowButtonPressed(userID: userid)),
                                    Navigator.pop(context),
                                    setState(() {
                                      user.follower = user.follower! - 1;
                                      btntext = (btntext == "Follow")
                                          ? "Following"
                                          : "Follow";
                                    })
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<HexColor>(
                                        HexColor("#3c1e08")),
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0))),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text(btntext),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<HexColor>(
                            HexColor("#F2EFEA")),
                        foregroundColor: MaterialStateProperty.all<HexColor>(
                            HexColor("#3c1e08")),
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
                      onPressed: () {
                        ChatListModel chatlist = ChatListModel(
                            userid: widget.userid ?? 0,
                            username: user.username,
                            fullname: user.fullname,
                            profileImage: user.profileImage,
                            latestMsg: "");
                        print("search user id = ${widget.userid}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleChatView(
                                  user: chatlist,
                                  existChat: false,
                                )));
                      },
                      child: Text("Message"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<HexColor>(
                            HexColor("#F2EFEA")),
                        foregroundColor: MaterialStateProperty.all<HexColor>(
                            HexColor("#3c1e08")),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            itemCount: cats.length,
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CatProfileView(
                                      currentcat: cats[index],
                                      fromOwner: false,
                                    ))).then((value) {
                              catBloc
                                  .add(SearchReloadAllCatEvent(userID: userid));
                              postBloc.add(LoadSearchAllPost(userid: userid));
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: HexColor("#3c1e08"),
                            radius: 40,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundImage: cats[index].profileImage != ""
                                  ? MemoryImage(base64Decode(
                                  cats[index].profileImage))
                              as ImageProvider<Object>
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
      ),
    );
  }

  Widget _getAllPosts() {
    return Card(
      color: HexColor("#ecd9c9"),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true, // Added shrinkWrap
          physics:
          NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
          itemCount: listPost.length,
          itemBuilder: (context, index) {
            final Post post = listPost[index];
            print("Post: ${post.toJson()}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.postImages != null && post.postImages!.isNotEmpty)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage: post.profileImage != ""
                            ? Image.memory(base64Decode(post.profileImage!))
                            .image
                            : AssetImage('assets/profileimage.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 4.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 6,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: post.description.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                displayImage(post),
                Row(
                  children: [
                    _FavoriteButton(
                      postId: post.id!,
                      actionTypeId: post.currentUserAction!,
                      onFavoriteChanged: (bool isThumbsUpSelected) {
                        setState(() {
                          post.likeCount =
                              post.likeCount! + (isThumbsUpSelected ? 1 : -1);
                        });
                        print('Is Thumbs Up Selected: $isThumbsUpSelected');
                      },
                    ),
                    SizedBox(width: 4.0),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Comments(postId: post.id!),
                        ),
                      ),
                      icon: Icon(
                        Icons.comment_bank_outlined,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${post.likeCount.toString()} likes",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Comments(postId: post.id!),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: post.commentCount! > 0
                              ? Text(
                            'View all ${post.commentCount} comments',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          )
                              : SizedBox.shrink(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          func.getFormattedDate(post.dateTime!),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget displayImage(Post post) {
    return post.postImages![0].image! != ""
        ? AspectRatio(
      aspectRatio: 1.0,
      child: Image.memory(
        base64Decode(post.postImages![0].image!),
        fit: BoxFit.cover,
      ),
    )
        : Container();
  }

  void refreshPosts() {
    postBloc.add(StartLoadOwnPost());
  }

/*
// Widget _getAllPosts(){
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1/1,
  //       crossAxisSpacing: 2,
  //       mainAxisSpacing: 2,
  //     ),
  //     itemBuilder: (context, index){
  //       final post = listPost[index];
  //
  //       return GestureDetector(
  //         onTap: (){
  //           //   handle one image
  //           //   new page
  //           //   wait for wafir's code
  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(currentPost: post)));
  //         },
  //         child: Container(
  //           color: Colors.grey,
  //           child: post.postImages != null && post.postImages!.isNotEmpty ?
  //           Image(image: MemoryImage(base64Decode(post.postImages![0].image!)),fit: BoxFit.cover,) : Container(),
  //         ),
  //       );
  //     },
  //     itemCount: listPost.length,
  //     reverse: true,
  //   );
  // } */
}

class _FavoriteButton extends StatefulWidget {
  final int postId;
  final int actionTypeId;
  final ValueChanged<bool> onFavoriteChanged;

  const _FavoriteButton({
    Key? key,
    required this.postId,
    required this.actionTypeId,
    required this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState(
    postId: postId,
    actionTypeId: actionTypeId,
    onFavoriteChanged: onFavoriteChanged,
  );
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool isFavorite = false;
  final GetPostBloc _postBloc = GetPostBloc();
  final int postId;
  final int actionTypeId;
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  final ValueChanged<bool> onFavoriteChanged;

  _FavoriteButtonState({
    required this.postId,
    required this.actionTypeId,
    required this.onFavoriteChanged,
  });
  @override
  void initState() {
    super.initState();

    // Initialize the state based on the provided actionTypeId
    if (actionTypeId == 1) {
      thumbsUpSelected = true;
    } else if (actionTypeId == 2) {
      thumbsDownSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              thumbsUpSelected = !thumbsUpSelected;
              if (thumbsUpSelected) {
                thumbsDownSelected = false;
              }
            });

            // Update the action type for the specific post
            if (thumbsUpSelected == true) {
              int newActionTypeId = 1;
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: newActionTypeId,
              ));
              onFavoriteChanged(thumbsUpSelected);
            } else if (thumbsUpSelected == false) {
              int newActionTypeId = 2;
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: newActionTypeId,
              ));
              onFavoriteChanged(thumbsUpSelected);
            }
          },
          icon: Icon(
            thumbsUpSelected ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            color: thumbsUpSelected ? Colors.blue : Colors.black,
            size: 24.0,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              thumbsDownSelected = !thumbsDownSelected;
              if (thumbsDownSelected) {
                thumbsUpSelected = false;
              }
            });

            // Update the action type for the specific post
            if (thumbsDownSelected == true) {
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: 2,
              ));
              onFavoriteChanged(thumbsUpSelected);
            }
          },
          icon: Icon(
            thumbsDownSelected
                ? Icons.thumb_down
                : Icons.thumb_down_alt_outlined,
            color: thumbsDownSelected ? Colors.red : Colors.black,
            size: 24.0,
          ),
        ),
      ],
    );
  }
}
