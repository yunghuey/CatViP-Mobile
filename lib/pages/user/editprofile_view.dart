import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:CatViP/bloc/user/userprofile_bloc.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CatViP/bloc/user/userprofile_event.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:geocoding/geocoding.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView> {
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  double lat  = 0.0, long = 0.0;
  final _formKey = GlobalKey<FormState>();
  int _gender = 2;
  late UserModel user;
  File? image;
  String base64image = "";
  final _picker = ImagePicker();
  DateTime currentDate = DateTime(1999);
  late UserProfileBloc userBloc;
  int profileEdited = 0;
  @override
  void initState() {
    // TODO: implement initState
    userBloc = BlocProvider.of<UserProfileBloc>(context);
    userBloc.add(StartLoadProfile());
    super.initState();
  }

  void _getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      lat = locations.first.latitude;
      long = locations.first.longitude;
      print('Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}');
    } on Exception catch (e) {
      print('Error: ${e.toString()}');
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
        title: Text('Edit profile', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<UserProfileBloc,UserProfileState>(
        listener: (context, state){
          if (state is UserProfileUpdated){
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User profile has been updated'))
            );
          }
        },
        child:BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state){
            if (state is UserProfileLoadingState){
              return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
            }
            else if (state is UserProfileUpdating){
              return Center(
                child:
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Updating...Please wait"),
                      SizedBox(height: 10),
                      CircularProgressIndicator(color:  HexColor("#3c1e08"),)
                    ],
                  )
              );
            }
            else if (state is UserProfileLoadedState){
              user = state.user;
              //   define the text controller
              if (fullnameController.text == ""){
                fullnameController.text = user.fullname;
              }
              if (addressController.text == "" && user.address != null && user.address!.isNotEmpty) {
                addressController.text = user.address!;
              }
              print("image: ${user.profileImage}");
              if (profileEdited == 0){
                base64image = user.profileImage!;
                profileEdited = 1;
                print("profile image initialized: ${profileEdited}");
              }

              if (currentDate == DateTime(1999)){
                String formatteddate = DateFormat("yyyy-MM-dd").format(DateTime.parse(user.dateOfBirth!));
                dateController.text = formatteddate;
                print("passed by this reset date");
                currentDate = DateTime.parse(user.dateOfBirth!);
              }
              if (_gender == 2){
                _gender = user.gender == true ? 1 :0;
              }

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _profileImage(),
                        _fullnameField(),
                        _addressField(),
                        _dobField(),
                        _genderField(),
                        _updateButton(),
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return Container();
            }
          },
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
              }
              else {
                return Center(
                  child: Image(
                  image: base64image != ""
                  ? MemoryImage(base64Decode(base64image)) as ImageProvider<Object>
                      : AssetImage('assets/profileimage.png'),
                  )
                );
              }
            },
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

  Widget _addressField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: addressController,
        maxLines: 3,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Address',
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
        onTap: () async {
          DateTime newpicked = await _selectDate();
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            String datedob = DateFormat("yyyy-MM-dd").format(newpicked);
            dateController.text = datedob;
            print("dateController after select date: ${dateController.text}");
            print("currentdate after select date: ${currentDate.toString()}");
;          });
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
          onPressed: () async {
            if(_formKey.currentState!.validate()){
              // success validation
              String username = user.username;
              String email = user.email!;
              String fullName = fullnameController.text.trim();
              String date = dateController.text;
              bool gender = _gender.toString() == 1 ? true : false;
              String address = addressController.text.trim().isNotEmpty ? addressController.text.trim() : "";
              String? profileImg;
              print(addressController.text.trim());
              print(fullnameController.text.trim());
              print(_gender.toString());
              print(dateController.text);
              if (image != null){
                Uint8List? imageData = await _getImageBytes(image!);
                if (imageData != null){
                  profileImg = base64Encode(Uint8List.fromList(imageData!));
                  print(profileImg);
                }
              } else {
                profileImg = base64image;
              }
              if (addressController.text != ""){
                _getCoordinates(addressController.text.trim());
              }
              UserModel userupdate = UserModel(
                username: username,
                email: email,
                fullname: fullName,
                gender: gender,
                dateOfBirth: date,
                address: address,
                profileImage: profileImg,
                longitude: long,
                latitude: lat,
              );
              userBloc.add(UpdateButtonPressed(user: userupdate));
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Having problem in updating user'))
              );
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
              Visibility(
                visible: base64image.isNotEmpty,
                child: TextButton.icon(
                  icon: Icon(Icons.delete, color: HexColor("#3c1e08")),
                  onPressed: () {
                    base64image = "";
                    setState(() {
                      image = null;
                    });
                    Navigator.pop(context);
                  },
                  label: Text("Remove", style: TextStyle(color:HexColor("#3c1e08")),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<DateTime> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime lastdob = DateTime(now.year - 10, now.month, now.day);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
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
        currentDate = picked;
      });
      return picked;
    }
    return currentDate;
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path as String);
      if (image != null){
        Uint8List? imageData = await _getImageBytes(image!);
        if (imageData != null){
          base64image = base64Encode(Uint8List.fromList(imageData!));
          print(base64image);
        }
      }
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }

}
