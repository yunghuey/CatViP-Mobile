import 'dart:convert';
import 'dart:typed_data';

import 'package:CatViP/repository/post_repo.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListUser(),
          bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildListUser(){
    return Card(
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

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display image
                            if (post.postImages != null && post.postImages!.isNotEmpty)
                              Container(
                                width: 350.0,
                                height: 350.0,
                                child: Image.memory(
                                  base64Decode(post.postImages![0].image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(height: 8.0), // Add spacing between image and description
                            // Display description
                            Text(
                              post.description.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 26.0,
                              ),
                            ),
                            SizedBox(height: 4.0),

                          ],
                        ),
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
