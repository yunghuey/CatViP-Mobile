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
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool hasBeenLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    cat = widget.currentcat;
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    postBloc = BlocProvider.of<GetPostBloc>(context);
    deleteBloc = BlocProvider.of<DeletePostBloc>(context);
    refreshPage();
    super.initState();
  }

  Future<void> refreshPage() async {
    catBloc.add(ReloadOneCatEvent(catid: cat.id));
    postBloc.add(StartLoadSingleCatPost(catid: cat.id));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CatProfileBloc, CatProfileState>(
          builder: (context, state){
            if (state is LoadedOneCatState) {
              final username = state.cat.name;
              return Text(
                username,
                style: Theme.of(context).textTheme.bodyLarge,
              );
            } else {
              return Text( widget.currentcat.name, style: Theme.of(context).textTheme.bodyLarge,);
            }
          },
        ),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: widget.fromOwner == true ? [
          BlocBuilder<CatProfileBloc, CatProfileState>(
              builder: (context, state) {
                if (state is LoadedOneCatState) {
                  return IconButton(
                    icon: Icon(Icons.edit, color: HexColor("#3c1e08"),),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          EditCatView(currentCat: widget.currentcat))
                      ).then((value) {
                        if (value != null) {
                          catBloc.add(ReloadOneCatEvent(catid: value));
                        }
                      });
                    },
                  );
                }
                else {
                  return Container();
                }
              }
          ),
        ] : [],
      ),
      body:
      BlocBuilder<CatProfileBloc, CatProfileState>(
        builder: (context, state){
          if (state is LoadedOneCatState){
            cat = state.cat;
            return RefreshIndicator(
              onRefresh: refreshPage,
              color: HexColor("#3c1e08"),
              child: Stack(
                children: <Widget>[
                  ListView(),
                  SingleChildScrollView(
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
                                catPostList = state.postList.reversed.toList();
                                return _getAllPosts();
                              }
                              return Container(child: Text("Create a post now!", style: TextStyle(fontSize: 16)));
                            }),
                      ],
                    ),
                  ),
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
    return Container(
      color: HexColor("#ecd9c9"),
      child: ListView.builder(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: catPostList.length,
        itemBuilder: (context, index) {
          final Post post = catPostList[index];
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
                          backgroundImage: cat.profileImage != ""
                              ? Image.memory(base64Decode(cat.profileImage!)).image
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
                                Text(cat.name,
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
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container(
                          color: Colors.brown,
                          padding: const EdgeInsets.all(
                              4.0), // Adjust the padding as needed
                          child: const Text(
                            "Expert Tips",
                            style: TextStyle(color: Colors.white),
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
                          const TextSpan(
                            text: ' ',
                          ),
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
              ? MediaQuery.of(context)
              .size
              .width
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
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? HexColor("#3c1e08")
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
                  : Container(),
            ],
          )
              : Container(),
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

