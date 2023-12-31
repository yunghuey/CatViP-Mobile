import 'dart:convert';
import 'package:CatViP/bloc/cat/catprofile_bloc.dart';
import 'package:CatViP/bloc/cat/catprofile_event.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/bloc/post/DeletePost/deletePost_bloc.dart';
import 'package:CatViP/bloc/post/DeletePost/deletePost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:CatViP/pages/cat/editcat_view.dart';
import 'package:CatViP/pages/post/comment.dart';
import 'package:CatViP/pages/user/editpost_view.dart';
import 'package:CatViP/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class CatProfileView extends StatefulWidget {
  final CatModel currentcat;
  final bool fromOwner;

  const CatProfileView({required this.currentcat, Key? key, required this.fromOwner}) : super(key: key);

  @override
  State<CatProfileView> createState() => _CatProfileViewState();
}

class _CatProfileViewState extends State<CatProfileView> {
  late CatProfileBloc catBloc;
  late GetPostBloc postBloc;
  late List<Post> catPostList;
  final Widgets func = Widgets();
  late DeletePostBloc deleteBloc;
  late CatModel cat;

  @override
  void initState() {
    // TODO: implement initState
    cat = widget.currentcat;
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    catBloc.add(ReloadOneCatEvent(catid: cat.id));
    postBloc = BlocProvider.of<GetPostBloc>(context);
    postBloc.add(StartLoadSingleCatPost(catid: cat.id));
    deleteBloc = BlocProvider.of<DeletePostBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name, style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: widget.fromOwner == true ? [
          IconButton(
            icon: Icon(Icons.edit, color: HexColor("#3c1e08"),),
            onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(builder: (context)=>EditCatView(currentCat: widget.currentcat))
              ).then((value) {
                if (value != null) {
                  catBloc.add(ReloadOneCatEvent(catid: value));
                }
              });
            },
          )
        ] : [],
      ),
      body:
      BlocBuilder<CatProfileBloc, CatProfileState>(
        builder: (context, state){
          if (state is LoadedOneCatState){
            cat = state.cat;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _catDetails(),
                  SizedBox(height: 10),
                  _catDesc(),
                  BlocBuilder<GetPostBloc, GetPostState>(
                      builder: (context, state){
                        if (state is GetPostLoading){
                          return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
                        }
                        else if (state is GetPostSingleCatLoaded){
                          catPostList = state.postList;
                          return _getAllPosts();
                        }
                        return Container(child: Text("Create a post now!", style: TextStyle(fontSize: 16)));
                      }),
                ],
              ),
            );
          } else if (state is CatProfileLoadingState){
            return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
          }
          else if (state is CatProfileEmptyState){
            return Container(
              margin: EdgeInsets.all(15.0),
              child: Text("No cat"),);
          }
          else {
            return Container();
          }
        }
      ),
    );
  }

  Widget _menu(){
    return Container(
    color: HexColor("#ecd9c9"),
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Edit Cat"),
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context)=>EditCatView(currentCat: widget.currentcat))
            ).then((value) {
              catBloc.add(ReloadOneCatEvent(catid: value));
            });
          },
        ),
      ],
    )
    );
  }

  Widget _profileImage(){
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape:BoxShape.circle,
        image: DecorationImage(
          image: cat.profileImage != ""
              ? MemoryImage(base64Decode(cat.profileImage))  as ImageProvider<Object>
              : AssetImage('assets/profileimage.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _catDesc(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
          children: [
            Text('"${cat.desc}"'),
          ],
      ),
    );
  }

  Widget _catProfile(){
    DateTime currentDate = DateTime.now();
    DateTime bday = DateTime.parse(cat.dob);
    String formatteddate = DateFormat("yyyy-MM-dd").format(bday);
    Duration difference = currentDate.difference(bday);
    int age = difference.inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Age: ${age.toString()} days", style: TextStyle(fontSize: 17)),
        SizedBox(height: 10),
        Text("Birthday: ${formatteddate.toString()}", style: TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _catDetails(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _profileImage(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _catProfile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAllPosts() {
    return Card(
      color: HexColor("#ecd9c9"),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true,
          // Added shrinkWrap
          physics: NeverScrollableScrollPhysics(),
          // Disable scrolling for the ListView
          itemCount: catPostList.length,
          itemBuilder: (context, index) {
            final Post post = catPostList[index];
            print("Post: ${post.toJson()}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.postImages != null && post.postImages!.isNotEmpty)
                  Row(
                    children: [
                      // CircleAvatar(
                      //   radius: 16,
                      //   backgroundColor: Colors.transparent,
                      //   backgroundImage: post.profileImage != ""
                      //       ? Image
                      //       .memory(base64Decode(post.profileImage!))
                      //       .image
                      //       : AssetImage('assets/profileimage.png'),
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (post.mentionedCats != null && post.mentionedCats!.isNotEmpty && post.mentionedCats![0].catName != null) ? post.mentionedCats![0].catName! : "no name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.fromOwner == true) IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shrinkWrap: true,
                                    children: [
                                      'Edit',
                                      'Delete'
                                    ]
                                        .map(
                                          (e) =>
                                          InkWell(
                                            onTap: () async {
                                              if (e == 'Edit') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPost(
                                                                currentPost: post))
                                                ).then((result) {
                                                  if (result == true){
                                                    Navigator.pop(context);
                                                    postBloc.add(StartLoadSingleCatPost(catid: cat.id));

                                                  }
                                                });
                                              } else if (e == 'Delete') {
                                                deleteBloc.add(
                                                    DeleteButtonPressed(
                                                        postId: post.id!));
                                                await Future.delayed(Duration(
                                                    milliseconds: 100));
                                                Navigator.pop(context);
                                                postBloc.add(
                                                    StartLoadOwnPost());
                                                //Navigator.push(context, MaterialPageRoute(builder: (context) => OwnPosts()));

                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
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
                      ) else Container(),
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
                      onPressed: () =>
                          Navigator.push(
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

  Widget displayImage(Post post){
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
            if(thumbsDownSelected == true) {
              _postBloc.add(UpdateActionPost(
                postId: postId,
                actionTypeId: 2,
              ));
              onFavoriteChanged(thumbsUpSelected);
            }
          },
          icon: Icon(
            thumbsDownSelected ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            color: thumbsDownSelected ? HexColor("#3c1e08") : Colors.black,
            size: 24.0,
          ),
        ),
      ],
    );
  }
}

