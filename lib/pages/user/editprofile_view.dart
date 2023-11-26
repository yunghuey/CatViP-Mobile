import 'dart:io';
import 'dart:typed_data';

import 'package:CatViP/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int _gender = 0;
  late UserModel user;
  File? image;
  String base64image = "";
  final _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    usernameController.text = "hello";
    super.initState();
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
        title: Text('Edit profile', style: Theme.of(context).textTheme.bodyLarge),
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
              children: [
                _profileImage(),
                _usernameField(),
                _emailField(),
                _fullnameField(),
                _dobField(),
                _genderField(),
                _updateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImage(){
    return GestureDetector(
      onTap: (){
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
              } else {
                // if profileimage got, display image, else display this
                return Center(
                  child: Image(image: AssetImage('assets/profileimage.png'),),
                );
              }
            },
          ),
        ),
    ),
    );
  }

  Widget _usernameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter username';
          }
          if (value.trim().contains(' ')){
            List<String> words = value.split(' ');
            if (words.length > 1){
              return 'Username cannot contain whitespace';
            }
          }
          return null;
        },
        controller: usernameController,
        decoration:  InputDecoration(
            prefixIcon: Icon(Icons.person, color: HexColor("#3c1e08"),),
            labelText: 'Username',
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

  Widget _emailField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter email';
          }
          if (!value.trim().contains('@')){
            return 'Email is not completed';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.email_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Email',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }

  Widget _fullnameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter full name';
          }
          return null;
        },
        controller: fullnameController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.account_box_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Full name',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }

  Widget _genderField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(

              border: Border(
                  bottom: BorderSide(
                    color: HexColor("#a4a4a4"),
                    width: 1.0,
                  )
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gender", style: TextStyle(fontSize: 16,),),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text('Male', style: TextStyle(fontSize: 14),),
                      value: 0,
                      activeColor: HexColor('#3c1e08'),
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text('Female', style: TextStyle(fontSize: 14),),
                      value: 1,
                      activeColor: HexColor('#3c1e08'),
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });                    },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _dobField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        readOnly: true,
        controller: dateController,
        decoration: InputDecoration(
          labelText: "Date of birth",
          prefixIcon: Icon(Icons.date_range_rounded, color: HexColor("#3c1e08"),),
          focusColor: HexColor("#3c1e08"),
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
        maxLines: 1,
        validator: (value){
          if (value!.isEmpty || value!.length < 1){
            return 'Choose Date';
          }
        },
        onTap: (){
          _selectDate();
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }

  Widget _updateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 300.0,
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
            child: Text('UPDATE', style: TextStyle(fontSize: 16),),
          ),
        ),
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
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera, color: HexColor("#3c1e08")),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                label: Text("Camera", style: TextStyle(color:HexColor("#3c1e08")),),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, color: HexColor("#3c1e08")),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                label: Text("Gallery", style: TextStyle(color:HexColor("#3c1e08")),),
              ),
              TextButton.icon(
                icon: Icon(Icons.delete, color: HexColor("#3c1e08")),
                onPressed: () {
                  base64image = "";
                  setState(() {
                    image = null;
                  });

                },
                label: Text("Remove", style: TextStyle(color:HexColor("#3c1e08")),),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _selectDate() async{
    DateTime now = DateTime.now();
    DateTime lastdob = DateTime(now.year - 10, now.month, now.day);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastdob,
      firstDate:  DateTime(1950),
      lastDate: lastdob,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            primarySwatch: Colors.brown,

          ),
          child: child!,
        );
      },
    );
    if (picked != null){
      setState(() {
        String datedob = DateFormat("yyyy-MM-dd").format(picked);
        dateController.text = datedob;
      });
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path as String);
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }


}
