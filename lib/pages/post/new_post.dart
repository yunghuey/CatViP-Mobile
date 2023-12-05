import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Add this import
import 'package:CatViP/bloc/post/new_post/new_post_bloc.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../bloc/post/new_post/new_post_event.dart';
import '../../bloc/post/new_post/new_post_state.dart';
import '../../model/post/postType.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  //Controllers for input
  TextEditingController captionController = TextEditingController();
  TextEditingController postTypeController = TextEditingController();
  TextEditingController catIdController = TextEditingController();

  List<PostType> postTypes = [];
  final _formKey = GlobalKey<FormState>();
  late NewPostBloc createBloc;
  PostType? selectedPostType;
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }



  Future<String?> _getImageBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(Uint8List.fromList(imageBytes));
      print(base64Encode(Uint8List.fromList(imageBytes)));
      //return base64String;
      return base64Encode(Uint8List.fromList(imageBytes));
    } catch (e) {
      print("Error reading image as bytes: $e");
      return null;
    }
  }

  late var msg = Container();
  late final status = BlocBuilder<NewPostBloc, NewPostState>(
    builder: (context, state){
      if (state is NewPostLoadingState){
        return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
      }
      return Container();
    },
  );

  @override
  void initState() {
    super.initState();
    createBloc = BlocProvider.of<NewPostBloc>(context);
    if (postTypes.isEmpty) {
      createBloc.add(GetPostTypes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add post"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ),
        body:  BlocListener<NewPostBloc, NewPostState>(
          // ignore: curly_braces_in_flow_control_structures
            listener: (context, state) {
              if (state is NewPostSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Post'))
                ); //   navigate to View All Cat

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
              else if (state is NewPostFailState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                );
              }
            },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      insertImage(context),
                      SizedBox(
                        height: 8.0,
                      ),
                      caption(),
                      SizedBox(
                        height: 8.0,
                      ),
                      postType(),
                      SizedBox(
                        height: 8.0,
                      ),
                      catId(),
                      SizedBox(
                        height: 8.0,
                      ),
                      postButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),

    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Image.",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              SizedBox(width: 20.0,),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget insertImage(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context)),
              );
            },
            child: Container(
              width: 300, // Set your desired width for the square box
              height: 300, // Set your desired height for the square box
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.brown,
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FutureBuilder<String?>(
                  future: image != null ? _getImageBase64(image!) : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Image.memory(
                        base64Decode(snapshot.data!),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Center(
                        child: Text('Pick Image'),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(context)),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.brown,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postButton() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () async {
            print(captionController.text);
            //if(_formKey.currentState!.validate()){
              if (image != null) {
                String? imageData = await _getImageBase64(image!);
                print(selectedPostType?.id);

                createBloc.add(PostButtonPressed(
                  description: captionController.text.trim(),
                  postTypeId: selectedPostType?.id ?? 0,
                  image: imageData,
                  catId: int.parse(catIdController.text.trim()),
                ));
              }
              else {
                print("image is null");
              }

            //}
          },

          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
            ),
            backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),

          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('POST', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );
  }

  Widget caption() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: captionController,
        decoration:  InputDecoration(
            labelText: 'Caption',
            labelStyle: TextStyle(color: HexColor("#3c1e08")),
            focusColor: HexColor("#3c1e08"),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  HexColor("#3c1e08")),
            )
        ),
      ),
    );
  }

  Widget postType() {
    //print('PostTypes: $postTypes');
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: BlocListener<NewPostBloc, NewPostState>(
        listener: (context, state) {
          if (state is GetPostTypeLoading) {
            // You can perform side-effects here if needed
          } else if (state is GetPostTypeError) {
            // You can perform side-effects here if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
              ),
            );
          } else if (state is GetPostTypeLoaded) {
            // Use the fetched data to populate the drop-down menu
            postTypes = state.postTypes;
            print("success");// Update the postTypes list
            // You can perform side-effects here if needed
          }
        },
        child: DropdownButtonFormField<PostType>(
          value: selectedPostType, // Replace with the selected PostType variable
          onChanged: (value) {
            setState(() {
              selectedPostType = value;
            });
          },
          items: postTypes.map((postType) {
            return DropdownMenuItem<PostType>(
              value: postType,
              child: Text(postType.name! ?? "no data"), // Replace with the actual field you want to display
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'PostType',
            labelStyle: TextStyle(color: HexColor("#3c1e08")),
            focusColor: HexColor("#3c1e08"),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#3c1e08")),
            ),
          ),
        ),
      ),
    );
  }

  Widget catId() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: catIdController,
        decoration:  InputDecoration(
            labelText: 'Cat Id',
            labelStyle: TextStyle(color: HexColor("#3c1e08")),
            focusColor: HexColor("#3c1e08"),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  HexColor("#3c1e08")),
            )
        ),
      ),
    );
  }


}
