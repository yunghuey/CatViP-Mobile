import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:CatViP/bloc/post/EditPost/editPost_event.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/post/EditPost/editPost_bloc.dart';
import '../../bloc/post/EditPost/editPost_state.dart';
import '../post/own_post.dart';

class EditPost extends StatefulWidget {

  final Post currentPost;
  const EditPost({super.key, required this.currentPost});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  late final Post post;
  File? image;
  String base64image = "";
  int id = 0;
  final _picker = ImagePicker();
  TextEditingController descController = TextEditingController();
  late EditPostBloc editPostBloc;
  PageController _pageController = PageController();
  int _currentPage = 0;

  Future<Uint8List?> _getImageBytes(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      return Uint8List.fromList(imageBytes);
    } catch (e) {
      print("Error reading image as bytes: $e");
      return null;
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    post = widget.currentPost;
    base64image = post.postImages!.isNotEmpty ? post.postImages![0].image ?? "" : "";
    id = post.id!;
    //nameController.text = cat.name;
    descController.text = post.description!;
    editPostBloc = BlocProvider.of<EditPostBloc>(context);
    /*
    dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(cat.dob));
    _gender = cat.gender == true ? 1 : 0;

    currentDate = DateTime.parse(dateController.text);

    catBloc.add(ReloadOneCatEvent(catid: widget.currentCat.id));*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPostBloc, EditPostState>(
      listener: (context, state) {
        if (state is EditPostSuccessState) {
          print('Post edited successfully');
          Navigator.pop(context, true);
        } else if (state is EditPostFailState) {
          print('Failed to save post');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Post",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: HexColor("#ecd9c9"),
          actions: [
            TextButton(
              onPressed: () {
                editPostBloc.add(
                  SaveButtonPressed(
                    description: descController.text,
                    postId: id,
                  ),
                );
                OwnPosts.ownPostsKey.currentState?.refreshPosts();
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  displayImage(widget.currentPost),
                  SizedBox(height: 4.0),
                  description(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget displayImage(Post post) {

    return Container(
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
                padding: EdgeInsets.all(8.0),
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
    );
  }

  Widget description(){
    return Column(
      children: [
        Text(
          'Description:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: descController,
          decoration: InputDecoration(
            hintText: 'Caption',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  HexColor("#3c1e08")),
            ),
            focusColor: HexColor("#3c1e08"),

          ),


        ),
      ],
    );
  }

}

