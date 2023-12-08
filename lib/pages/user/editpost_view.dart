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
          Navigator.pop(context);
          print('Post edited successfully');
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
                  postImage(),
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

  Widget postImage() {
    return Center(
      child: Container(
        width: 350, // Set your desired width for the square box
        height: 350, // Set your desired height for the square box
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor("#3c1e08"),
            width: 2.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FutureBuilder<Uint8List?>(
            future: image != null ? _getImageBytes(image!) : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                );
              }
              else {
                return Center(
                    child: Image(
                      image: base64image != ""
                          ? MemoryImage(base64Decode(base64image)) as ImageProvider<Object>
                          : AssetImage('assets/catprofileimg.png'),
                    )
                );
              }
            },
          ),
        ),
      ),
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
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

}

