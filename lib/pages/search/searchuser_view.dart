import 'dart:convert';
import 'package:CatViP/bloc/post/DeletePost/deletePost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/search/cat/searchcat_bloc.dart';
import 'package:CatViP/bloc/search/cat/searchcat_event.dart';
import 'package:CatViP/bloc/search/cat/searchcat_state.dart';
import 'package:CatViP/bloc/search/post/searchpost_bloc.dart';
import 'package:CatViP/bloc/search/post/searchpost_event.dart';
import 'package:CatViP/bloc/search/post/searchpost_state.dart';
import 'package:CatViP/bloc/search/user/searchuser_bloc.dart';
import 'package:CatViP/bloc/search/user/searchuser_event.dart';
import 'package:CatViP/bloc/search/user/searchuser_state.dart';
import 'package:CatViP/bloc/user/relation_bloc.dart';
import 'package:CatViP/bloc/user/relation_event.dart';
import 'package:CatViP/bloc/user/relation_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/pages/SnackBarDesign.dart';
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
  late List<Post> postList;
  late UserModel user;
  late SearchUserBloc searchBloc;
  late SearchPostBloc postBloc;
  late SearchCatBloc catBloc;
  late RelationBloc relBloc;
  late DeletePostBloc deleteBloc;
  final Widgets func = Widgets();
  bool isSet = false;
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool hasBeenLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    userid = widget.userid;
    print("inside search user ${userid}");
    searchBloc = BlocProvider.of<SearchUserBloc>(context);
    catBloc = BlocProvider.of<SearchCatBloc>(context);
    postBloc = BlocProvider.of<SearchPostBloc>(context);
    relBloc = BlocProvider.of<RelationBloc>(context);
    deleteBloc = BlocProvider.of<DeletePostBloc>(context);
    refreshPage();
    super.initState();
  }

  Future<void> refreshPage() async {
    searchBloc.add(SearchUserProfileEvent(userid: userid));
    catBloc.add(SearchReloadAllCatEvent(userID: userid));
    postBloc.add(LoadSearchAllPostEvent(userid: userid));
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
              final snackBar = SnackBarDesign.customSnackBar(state.message);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                  color: HexColor("#3c1e08"),
                  onRefresh: refreshPage,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _userDetails(),
                        BlocBuilder<SearchCatBloc, SearchCatProfileState>(
                          builder: (context, state) {
                            if (state is SearchCatLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: HexColor("#3c1e08"),
                                ),
                              );
                            } else if (state is SearchCatProfileLoadedState) {
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
                        BlocBuilder<SearchPostBloc,SearchGetPostState >(
                          builder: (context, state) {
                            if (state is SearchPostLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: HexColor("#3c1e08"),
                                ),
                              );
                            } else if (state is SearchGetPostSuccessState) {
                              postList = state.posts.reversed.toList();
                              return _getAllPosts();
                            } else {
                              return Center(
                                child: Container(
                                  child: const Text(
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
                        const Text("Searching....."),
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
                : const AssetImage('assets/profileimage.png'),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _followers() {
    return Column(
      children: [
        Text(
          user.follower.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Text("Followers"),
      ],
    );
  }

  Widget _following() {
    return Column(
      children: [
        Text(
          user.following.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Text("Following"),
      ],
    );
  }

  Widget _tipsPost() {
    if (user.isExpert == true) {
      return Column(
        children: [
          Text(
            user.expertTips.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const Text("Tips"),
        ],
      );
    } else {
      return const Column();
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
                    padding: const EdgeInsets.all(5),
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
                                        const EdgeInsets.all(10.0)),
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
                                  child: const Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<HexColor>(
                                        HexColor("#3c1e08")),
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(10.0)),
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
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        ChatListModel chatlist = ChatListModel(
                          userid: widget.userid ?? 0,
                          username: user.username,
                          fullname: user.fullname,
                          profileImage: user.profileImage,
                          latestMsg: "",
                          unreadMessage: 0
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleChatView(
                                  user: chatlist,
                                  existChat: false,
                                )));
                      },
                      child: const Text("Message"),
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
                                    ))).then((value) { refreshPage(); });
                          },
                          child: CircleAvatar(
                            backgroundColor: HexColor("#3c1e08"),
                            radius: 40,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundImage: cat.profileImage != ""
                                  ? MemoryImage(base64Decode(
                                  cat.profileImage))
                              as ImageProvider<Object>
                                  : const AssetImage('assets/profileimage.png'),
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
    return Container(
      color: HexColor("#ecd9c9"),
      child: ListView.builder(
        shrinkWrap: true, // Added shrinkWrap
        physics:
        const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
        itemCount: postList.length,
        itemBuilder: (context, index) {
          final Post post = postList[index];
          return Card(
            color: HexColor("#ecd9c9"),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.transparent,
                          backgroundImage: user.profileImage != ""
                              ? Image.memory(base64Decode(user.profileImage!)).image
                              : const AssetImage('assets/profileimage.png'),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(user.fullname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        post.postTypeId == 1
                            ? Container(
                          color: Colors.brown,
                          padding: const EdgeInsets.all(
                              4.0), // Adjust the padding as needed
                          child: const Text(
                            "Daily Sharing",
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        )
                            : Container(
                          color: Colors.brown,
                          padding: const EdgeInsets.all(
                              4.0), // Adjust the padding as needed
                          child: const Text(
                            "Expert Tips",
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 6,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: ' ',),
                          TextSpan(
                            text: post.description.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  displayImage(post),
                  Row(
                    children: [
                      _FavoriteButton(
                        postId: post.id!,
                        actionTypeId: post.currentUserAction!,
                        onFavoriteChanged:
                            (bool isThumbsUpSelected) {
                          if (post.likeCount != 0 ||
                              isThumbsUpSelected) {
                            setState(() {
                              post.likeCount =
                                  post.likeCount! +
                                      (isThumbsUpSelected
                                          ? 1
                                          : -1);
                              hasBeenLiked = true;
                            });
                          } else {
                            print(
                                'Is Thumbs Up Selected: $isThumbsUpSelected');
                          }
                        },
                      ),
                      const SizedBox(width: 4.0),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Comments(postId: post.id!),
                          ),
                        ),
                        icon: const Icon(
                          Icons.comment_bank_outlined,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post.likeCount.toString()} likes",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Comments(
                                        postId: post.id!),
                              ),
                            );
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 4),
                            child: post.commentCount! > 0
                                ? Text(
                              'View all ${post.commentCount} comments',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4),
                          child: Text(
                            func.getFormattedDate(
                                post.dateTime!),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displayImage(Post post) {
    return Stack(
      children: [
        Container(
          height: post.postImages != null && post.postImages!.isNotEmpty
              ? MediaQuery.of(context).size.width
              : 0,
          child: post.postImages != null && post.postImages!.isNotEmpty
              ? Column(
                children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: post.postImages!.length,
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.memory(
                        base64Decode(post.postImages![index].image!),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                ),
              ),
              post.postImages!.length > 1
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  post.postImages!.length,
                      (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? HexColor(
                            "#3c1e08") // Highlight the current page indicator
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
                  : Container(),
            ],
          )
              : Container(), // Show an empty container if postImages is null or empty
        ),
      ],
    );
  }
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
            color: thumbsUpSelected ? HexColor("#3c1e08") : Colors.black,
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
            color: thumbsDownSelected ? HexColor("#3c1e08") : Colors.black,
            size: 24.0,
          ),
        ),
      ],
    );
  }
}
