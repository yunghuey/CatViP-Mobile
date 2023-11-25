import 'dart:convert';
import 'dart:typed_data';

import 'package:CatViP/repository/post_repo.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post/post.dart';

import '../pageRoutes/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final GetPostBloc _postBloc = GetPostBloc();
  bool isFavorite = false;

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
          title: Text('CatViP'),
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.messenger_outline),
                color: Colors.white,
            ),
          ],
        ),
        body: _buildListUser(),
          bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildListUser(){
    return Card(
      color: HexColor("#ecd9c9"),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (context) => _postBloc,
          child: BlocBuilder<GetPostBloc,GetPostState>(
            builder: (context, state) {
              if (state is GetPostError) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (state is GetPostInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetPostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetPostLoaded) {
                return ListView.builder(
                  itemCount: state.postList.length,
                  itemBuilder: (context, index) {
                    Post post = state.postList[index];
                    print("Post: ${post.toJson()}");
                    return Container(
                          color: HexColor("#ecd9c9"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display image
                              if (post.postImages != null && post.postImages!.isNotEmpty)
                                Container(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage('assets/addImage.png'),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('username',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(onPressed: (){
                                        showDialog(context: context, builder: (context) => Dialog(
                                          child: ListView(
                                            padding: const EdgeInsets.symmetric(vertical: 16,),
                                            shrinkWrap: true,
                                            children: [
                                              'Report',
                                            ]
                                                .map(
                                                  (e) => InkWell(
                                                    onTap: (){},
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                   ),
                                                 )
                                                .toList(),
                                              ),
                                            ),
                                        );
                                      },
                                          icon: const Icon(Icons.more_vert),),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 4.0),
                                Center(
                                  child: Container(
                                    width: 400.0,
                                    height: 400.0,
                                    child: Image.memory(
                                      base64Decode(post.postImages![0].image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Row(
                                  children: [
                                    _FavoriteButton(),
                                    SizedBox(width: 4.0),
                                    IconButton(
                                      onPressed: () {

                                      },
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
                                    Text (
                                      "${post.likeCount.toString()} likes",
                                      style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                      ),
                               ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: post.id.toString(),
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
                                            ]
                                  )
                                  ),
                                ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: post.commentCount! > 0 // Add your condition here
                                            ? Text(
                                          'View all ${post.commentCount} comments',
                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                        )
                                            : SizedBox.shrink(), // Use SizedBox.shrink() to conditionally hide the widget
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        getFormattedDate(post.dateTime!),                                      style: const TextStyle(fontSize: 16, color: Colors.black),
                                      )
                                    ),
                                  ],
                               ),
                              ),
                            ],
                          ),
                    );
                  },
                );
                } else {
                  return Container();
              }
            }
          ),
        ),
      ),
    );
  }

  String getFormattedDate(DateTime dateTime) {
    final now = DateTime.now();

    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      // Date is the same as the local date, calculate time difference in hours and minutes
      final timeDifference = now.difference(dateTime);

      print('timeDifference.inDays: ${timeDifference.inDays}');

      if (timeDifference.inHours > 0) {
        // If the time difference is in hours, display hours
        return "${timeDifference.inHours} ${timeDifference.inHours == 1 ? 'hour' : 'hours'} ago";
      } else if (timeDifference.inMinutes > 0) {
        // If the time difference is in minutes, display minutes
        return "${timeDifference.inMinutes} ${timeDifference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      } else {
        // If the time difference is less than a minute, display 'just now'
        return 'just now';
      }
    } else {
      // Date is not the same as the local date, display only the date
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
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
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.black,
        size: 24.0,
      ),
    );
  }
}
