import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Add this import
import 'package:CatViP/bloc/post/OwnCats/ownCats_bloc.dart';
import 'package:CatViP/bloc/post/OwnCats/ownCats_event.dart';
import 'package:CatViP/bloc/post/OwnCats/ownCats_state.dart';
import 'package:CatViP/bloc/post/new_post/new_post_bloc.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/post/new_post/new_post_event.dart';
import '../../bloc/post/new_post/new_post_state.dart';
import '../../model/cat/cat_model.dart';
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
  List<CatModel> cats = [];
  final _formKey = GlobalKey<FormState>();
  late NewPostBloc createBloc;
  late OwnCatsBloc catBloc;
  PostType? selectedPostType;
  int? selectedCatId;
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;
  late final String message;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }

  Future<String> getMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String message = prefs.getString('message') ?? '';

    return message;
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

  PostType getInitialPostType() {
    if (postTypes.isNotEmpty) {
      return postTypes[0];
    } else {
      return PostType(id: 0, name: "Default", error: '');
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
    createBloc.add(GetPostTypes());
    catBloc = BlocProvider.of<OwnCatsBloc>(context);
    selectedPostType = getInitialPostType();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add post", style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: HexColor("#3c1e08"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ),
        body:  MultiBlocListener(
          listeners: [
            BlocListener<NewPostBloc, NewPostState>(
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
                    getMessage().then((message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message))
                      );
                    });
                  }
                },
            ),

          ],
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
                      if (selectedPostType != null && selectedPostType?.id == 1)
                      OwnCats(),
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
            "Choose Image",
            style: TextStyle(
              fontSize: 20.0,
              color: HexColor("#3c1e08"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera,color: HexColor("#3c1e08"),),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                label: Text("Camera", style: TextStyle(color: HexColor("#3c1e08")),),
              ),
              SizedBox(width: 20.0,),
              TextButton.icon(
                icon: Icon(Icons.image,color: HexColor("#3c1e08"),),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                label: Text("Gallery", style: TextStyle(color: HexColor("#3c1e08")),),
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
                print("posttype ${selectedPostType?.id}");

                createBloc.add(PostButtonPressed(
                  description: captionController.text.trim(),
                  postTypeId: selectedPostType?.id ?? 0,
                  image: imageData ?? '',
                  catId: selectedCatId ?? 0,
                ));
              }
              else {
                print("image is null");
                createBloc.add(PostButtonPressed(
                  description: captionController.text.trim(),
                  postTypeId: selectedPostType?.id ?? 0,
                  image: '',
                  catId: selectedCatId ?? 0,
                ));
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
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: BlocBuilder<NewPostBloc, NewPostState>(
        builder: (context, state) {
          if (state is GetPostTypeLoading) {
            return CircularProgressIndicator(color: HexColor("#3c1e08"));
          } else if (state is GetPostTypeError) {
            return Text('Error: ${state.error}');
          } else if (state is GetPostTypeLoaded) {
            postTypes = state.postTypes;

            // If selectedPostType is null, set it to the first post type
            if (selectedPostType == null && postTypes.isNotEmpty) {
              selectedPostType = postTypes.first;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PostType',
                  style: TextStyle(color: HexColor("#3c1e08")),
                ),
                SizedBox(height: 10.0),
                Wrap(
                  spacing: 8.0,
                  children: postTypes.map((postType) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<PostType>(
                          value: postType,
                          groupValue: selectedPostType,
                          onChanged: (value) {
                            setState(() {
                              selectedPostType = value!;
                            });
                          },
                        ),
                        Text(postType.name! ?? "no data"),
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          } else {
            // Handle other states if needed
            return Container();
          }
        },
      ),
    );
  }

  Widget OwnCats() {
    //print('PostTypes: $postTypes');
    catBloc.add(GetOwnCats());
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: BlocListener<OwnCatsBloc, OwnCatsState>(
        listener: (context, state) {
          if (state is GetOwnCatsLoading) {
            // You can perform side-effects here if needed
          } else if (state is GetOwnCatsError) {
            // You can perform side-effects here if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
              ),
            );
          } else if (state is GetOwnCatsLoaded) {
            // Use the fetched data to populate the drop-down menu
            cats = state.cats;
            print("success");// Update the OwnCats list
            // You can perform side-effects here if needed
          }else{
            print('tak jadi bey');
          }
        },
        child: DropdownButtonFormField<int>(
          value: selectedCatId, // Replace with the selected cat variable
          onChanged: (value) {
            setState(() {
              selectedCatId = value;
            });
          },
          items: cats.map((cat) {
            return DropdownMenuItem<int>(
              value: cat.id,
              child: Text(cat.name! ?? "no data"), // Replace with the actual field you want to display
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Cat',
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


}
