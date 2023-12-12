import 'dart:convert';
import 'package:CatViP/pages/post/comment.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post/post.dart';
import '../pageRoutes/bottom_navigation_bar.dart';
import '../widgets/widgets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final GetPostBloc _postBloc = GetPostBloc();
  int? selectedPostIndex;
  late final int? postId;
  final Widgets func = Widgets();
  bool isFavorite = false;
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  bool hasBeenLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    _postBloc.add(GetPostList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    retrieveSharedPreference();
    return BlocProvider(
      create: (context) => _postBloc,
      child: Scaffold(
        appBar: AppBar(
          //flexibleSpace: _logoImage(),
          title: Text('CatViP',style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.messenger_outline, color: HexColor("#3c1e08"),),
              color: Colors.white,
            ),
          ],
        ),
        body: _buildListUser(),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Future<void> refreshPosts() async {
    _postBloc.add(StartLoadOwnPost());
  }

  Widget _buildListUser() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocProvider(
        create: (context) => _postBloc,
        child: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state is GetPostError) {
              return Center(
                child: Text(state.error!),
              );
            } else if (state is GetPostInitial || state is GetPostLoading) {
              return Center(
                child: CircularProgressIndicator(color:  HexColor("#3c1e08")),
              );
            } else if (state is GetPostLoaded) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(primary: HexColor("#3c1e08")),
                ),
                child: RefreshIndicator(
                  onRefresh: refreshPosts,
                  child: ListView.builder(
                    itemCount: state.postList.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final Post post = state.postList[index];
                      print("Post: ${post.toJson()}");
                      return Card(
                        color: HexColor("#ecd9c9"),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post.postImages != null &&
                                  post.postImages!.isNotEmpty)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: post.profileImage != ""
                                          ? Image.memory(base64Decode(post.profileImage!)).image
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
                                              post.username!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: ListView(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shrinkWrap: true,
                                              children: [
                                                'Report',
                                              ]
                                                  .map(
                                                    (e) => InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 12, horizontal: 16),
                                                    child: Text(e),
                                                  ),
                                                ),
                                              )
                                                  .toList(),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 4.0),
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.memory(
                                  base64Decode(post.postImages![0].image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  _FavoriteButton(
                                    postId: post.id!,
                                    actionTypeId: post.currentUserAction!,
                                    onFavoriteChanged: (bool isThumbsUpSelected) {
                                      if(post.likeCount != 0 || isThumbsUpSelected) {
                                        setState(() {
                                          post.likeCount = post.likeCount! +
                                              (isThumbsUpSelected ? 1 : -1);
                                          hasBeenLiked = true;
                                        });
                                      }else{
                                        print('Is Thumbs Up Selected: $isThumbsUpSelected');
                                      }
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
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
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                        top: 6,
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: post.mentionedCats?[0].catName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
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
                                          style: const TextStyle(fontSize: 14, color: Colors.black),
                                        )
                                            : SizedBox.shrink(),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        func.getFormattedDate(post.dateTime!),
                                        style: const TextStyle(fontSize: 12, color: Colors.black),
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
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }


  Future<void> retrieveSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('token'); // Replace 'yourKey' with the key you used when saving the value

    if (savedValue != null) {
      // Use the retrieved value as needed
      print('Retrieved value: $savedValue');
    } else {
      print('Value not found in SharedPreferences');
    }
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
            if(thumbsUpSelected == true) {
              int newActionTypeId = 1;
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: newActionTypeId,
              ));
              onFavoriteChanged(thumbsUpSelected);
            } else if(thumbsUpSelected == false) {
              _postBloc.add(DeleteActionPost(
                  postId: postId
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
            if(thumbsDownSelected == true) {
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: 2,
              ));
              onFavoriteChanged(thumbsUpSelected);
            }else{
              _postBloc.add(DeleteActionPost(
                  postId: postId
              ));
              //onFavoriteChanged(thumbsUpSelected);
            }
          },
          icon: Icon(
            thumbsDownSelected ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            color: thumbsDownSelected ? Colors.red : Colors.black,
            size: 24.0,
          ),
        ),
      ],
    );
  }
}