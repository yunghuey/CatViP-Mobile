import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:CatViP/model/post/post.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

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
  final _picker = ImagePicker();

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
    /*nameController.text = cat.name;
    descController.text = cat.desc;
    dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(cat.dob));
    _gender = cat.gender == true ? 1 : 0;

    currentDate = DateTime.parse(dateController.text);
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    catBloc.add(ReloadOneCatEvent(catid: widget.currentCat.id));*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Cat", style: Theme
              .of(context)
              .textTheme
              .bodyLarge,),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body:
/*        BlocListener<CatProfileBloc, CatProfileState>(
          listener: (context, state) {
            if (state is CatUpdateSuccessState) {
              print(Navigator.of(context).toString());
              Navigator.pop(context, cat.id);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cat profile has been updated'))
              );
            }
            else if (state is CatUpdateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message),)
              );
            }
            else if (state is CatDeleteSuccessState) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileView(),
                ),
                    (route) => false, // Pop until there are no more routes
              );
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message),)
              );
            }
          },*/
         /* child: */SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    username(),
                  ],
                ),
              ),
            ),
          ),
        );
  //  );
  }

  Widget username() {
    return Container(
      width: 250, // Set your desired width for the square box
      height: 250, // Set your desired height for the square box
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
    );
  }

}

