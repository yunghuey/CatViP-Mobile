import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:CatViP/bloc/cat/catprofile_bloc.dart';
import 'package:CatViP/bloc/cat/catprofile_event.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/pages/user/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCatView extends StatefulWidget {
  final CatModel currentCat;
  const EditCatView({required this.currentCat, Key? key}) : super(key: key);

  @override
  State<EditCatView> createState() => _EditCatViewState();
}

class _EditCatViewState extends State<EditCatView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late CatProfileBloc catBloc;
  final _formKey = GlobalKey<FormState>();
  int _gender = 2;
  late CatModel cat;
  File? image;
  String base64image = "";
  final _picker = ImagePicker();
  DateTime currentDate = DateTime(1999);
  late CatProfileBloc userBloc;
  int profileEdited = 0;

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
    catBloc = BlocProvider.of<CatProfileBloc>(context);
    catBloc.add(EditCatProfileEvent(catid: widget.currentCat.id));
    super.initState();
  }

  final msg = BlocBuilder<CatProfileBloc, CatProfileState>(
      builder: (context, state){
          if (state is CatProfileLoadingState){
            return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
          } else{
            return Container();
          }
      },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Cat", style: Theme.of(context).textTheme.bodyLarge,),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<CatProfileBloc,  CatProfileState>(
        listener: (context, state){
          if (state is CatUpdateSuccessState){
            print(Navigator.of(context).toString());
            Navigator.pop(context, cat.id);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cat profile has been updated'))
            );
          }
          else if (state is CatUpdateErrorState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),)
            );
          }
          else if (state is CatDeleteSuccessState){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProfileView(),),(route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),)
            );
          }
        },
        child:
        BlocBuilder<CatProfileBloc,CatProfileState>(
          builder: (context, state){
            if (state is CatProfileEmptyState){
              return Center(child: Text("Error in getting cat details. Please refresh"));
            }
            else if (state is CatProfileLoadingState){
              return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
            }
            else if (state is GetCatProfileEditState){
              if (profileEdited == 0){
                cat = state.cat;
                nameController.text = cat.name;
                descController.text = cat.desc;
                dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(cat.dob));
                _gender = cat.gender == true ? 1 : 0;
                base64image = cat.profileImage;
                currentDate = DateTime.parse(dateController.text);
                profileEdited = 1;
              }
              return _editCatForm();
            }
            return Container();
          }
        ),

      )
    );
  }

  Widget _editCatForm(){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              _profileImage(),
              _nameField(),
              _descField(),
              _dobField(),
              _genderField(),
              msg,
              _buttonGroup(),
            ],
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
                  fit: BoxFit.contain,
                );
              }
              else {
                return Center(
                    child: Image(
                      image: base64image != ""
                          ? MemoryImage(base64Decode(base64image)) as ImageProvider<Object>
                          : AssetImage('assets/catprofileimg.png'),
                      fit: BoxFit.contain,
                    )
                );
              }
            },
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

  Widget _nameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter cat name';
          }
          return null;
        },
        controller: nameController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.account_box_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Cat name',
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

  Widget _descField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter description';
          }
          return null;
        },
        controller: descController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.text_format_outlined, color: HexColor("#3c1e08"),),
          labelText: 'Description',
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

  Future<DateTime> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate:  DateTime(1950),
      lastDate: now,
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

  Widget _buttonGroup(){
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              child: Text("Update", style: TextStyle(fontSize: 15, color: Colors.white),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
              ),
              onPressed: (){
                if (_formKey.currentState!.validate()){
                  int id = widget.currentCat.id;
                  String name = nameController.text.trim();
                  String desc = descController.text.trim();
                  String date = dateController.text.trim();
                  bool gender = _gender.toString() == 1 ? true : false;
                  if (base64image.isNotEmpty){
                    CatModel newCat = CatModel(
                      id: id,
                      name: name,
                      desc: desc,
                      dob: date,
                      profileImage: base64image,
                      gender: gender,
                    );

                    print(newCat.toString());
                    catBloc.add(UpdateCatPressed(cat: newCat));
                  }
                  else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Missing image'),
                        content: const Text('Please upload your cat\'s profile picture'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }

                }

              },

            ),
          ),
          SizedBox(width: 4.0),
          Expanded(
            child: TextButton(
              onPressed: (){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Remove Cat'),
                    content: const Text('Are you sure to remove this cat?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text('Cancel',style: TextStyle(color: HexColor('#3c1e08'))),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<HexColor>(
                                  (Set<MaterialState> states){
                                if(states.contains(MaterialState.pressed))
                                  return HexColor("#ecd9c9");
                                return HexColor("#F2EFEA");
                              }
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10.0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                        ),

                      ),
                      TextButton(
                        onPressed: () => catBloc.add(DeleteCatPressed(catid: cat.id)),
                        child:  Text('Yes',style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10.0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete",style: TextStyle(fontSize: 15, color: HexColor("#3c1e08"))),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                side: MaterialStateProperty.all(
                  BorderSide(color: HexColor("#3c1e08"))),
              ),
            )

          ),
        ],
      ),
    );
  }

}
