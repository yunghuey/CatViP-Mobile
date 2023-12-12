import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:CatViP/bloc/cat/new_cat/createcat_bloc.dart';
import 'package:CatViP/bloc/cat/new_cat/createcat_event.dart';
import 'package:CatViP/bloc/cat/new_cat/createcat_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateCatView extends StatefulWidget {
  const CreateCatView({super.key});

  @override
  State<CreateCatView> createState() => _CreateCatViewState();
}

class _CreateCatViewState extends State<CreateCatView> {
  TextEditingController catnameController = TextEditingController();
  TextEditingController catdescController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _gender = 0;

  late CreateCatBloc createBloc;
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

  late var msgimage = Container();
  late final formstatus = BlocBuilder<CreateCatBloc, CreateCatState>(
    builder: (context, state){
      if (state is CreateCatLoadingState){
        return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
      }
      return Container();
    },
  );

  @override
  void initState() {
    super.initState();
    createBloc = BlocProvider.of<CreateCatBloc>(context);
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
      body:
      BlocListener<CreateCatBloc, CreateCatState>(
        // ignore: curly_braces_in_flow_control_structures
        listener: (context, state) {
          if (state is CreateCatSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cat is created successfully'))
            ); //   navigate to View All Cat
            Navigator.pop(context, true);
            //   set texteditingcontroller to empty
          }
          else if (state is CreateCatFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
            );
          }
        } ,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _catImageText(),
                  SizedBox(height: 10.0),
                  _insertImage(context),
                  msgimage,
                  _catNameField(),
                  SizedBox(height: 5.0),
                  _catNameText(),
                  _catgenderField(),
                  _catdobField(),
                  _catDescField(),
                  SizedBox(height: 15.0),
                  formstatus,
                  _createCatButton(),
                ],
              ),
            ),
          ),
        ),// listener

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

  Widget _catgenderField() {
    return Padding(
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
    );
  }

  Future<void> _selectDate() async{
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
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
      });
    }
  }

  Widget _catdobField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        readOnly: true,
        controller: dateController,
        decoration: InputDecoration(
          labelText: "Date of birth",
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


  Widget _catImageText(){
    return Text("Choose a profile image for cat", style: TextStyle(fontSize: 16),);
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
                      // Navigator.pop(context);
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
                color: HexColor("#3c1e08"),
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
          onPressed: () async {
            if(_formKey.currentState!.validate()){
              // success validation
              if (image != null) {
                Uint8List? imageData = await _getImageBytes(image!);
                if (imageData != null){
                  String base64String = base64Encode(Uint8List.fromList(imageData));
                  print(base64String);
                //   continue create cat process
                  bool gender_ = _gender == 1 ? true : false;
                  CatModel cat = CatModel(
                    id: 0,
                    name: catnameController.text.trim(),
                    desc: catdescController.text.trim(),
                    dob: dateController.text,
                    gender: gender_,
                    profileImage: base64String
                  );

                createBloc.add(CreateButtonPressed(cat: cat));
                }
              } else {
                setState(() {
                  msgimage = Container(child: Text("Please insert an image", style: TextStyle(color: Colors.red),));
                });
              }
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
