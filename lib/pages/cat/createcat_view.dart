import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';


class CreateCatView extends StatefulWidget {
  const CreateCatView({super.key});

  @override
  State<CreateCatView> createState() => _CreateCatViewState();
}

class _CreateCatViewState extends State<CreateCatView> {
  TextEditingController catnameController = TextEditingController();
  TextEditingController catdescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? image;
  final _picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path as String);
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new cat', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _catNameField(),
                SizedBox(height: 5.0),
                _catNameText(),
                _catDescField(),
                SizedBox(height: 15.0),
                _catImageText(),
                SizedBox(height: 10.0),
                _insertImage(context),
                _createCatButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _catNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter a cat name';
          }
          if (value.trim().contains(' ')){
            List<String> words = value.split(' ');
            if (words.length > 1){
              return 'Cat name cannot contain whitespace';
            }
          }
          return null;
        },
        controller: catnameController,
        decoration:  InputDecoration(
            labelText: 'Cat Name',
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

  Widget _catDescField(){
    return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty){
          return 'Please enter cat description';
        }
        if (value.trim().contains(' ')){
          List<String> words = value.split(' ');
          if (words.length > 1){
            return 'Cat name cannot contain whitespace';
          }
        }
        return null;
      },
      controller: catdescController,
      decoration:  InputDecoration(
          labelText: 'Cat Description/Biodata',
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

  Widget _catImageText(){
    return Text("Choose a profile image", style: TextStyle(fontSize: 16),);
  }

  Widget _catNameText(){
    return Text("Cat name cannot contain space",style: TextStyle(fontSize: 13),);
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

  Widget _insertImage(BuildContext context) {
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
              width: 250, // Set your desired width for the square box
              height: 250, // Set your desired height for the square box
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.teal,
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
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCatButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              // success validation
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
            ),
            backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),

          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Create cat account', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );
  }
}
