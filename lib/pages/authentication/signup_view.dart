import 'package:CatViP/pages/RoutePage.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:CatViP/pages/user/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/bloc/authentication/register/register_event.dart';
import 'package:CatViP/bloc/authentication/register/register_state.dart';
import 'package:CatViP/bloc/authentication/register/register_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  static Future<bool> getToken() async{
    print('trying to get token');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null){
      return true;
    }else {
      return false;
    }
  }

    @override
    State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmpwdController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String password = '';
  String confirmpassword = '';

  late RegisterBloc registerBloc;
  late double lat, long;

  int _gender = 0;
  // 0 means false - male
  // 1 means true - female

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerBloc = BlocProvider.of<RegisterBloc>(context);
  }
  @override
  Widget build(BuildContext context) {

    final msg = BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state){
        if (state is RegisterLoadingState){
          return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
        }
        return Container();
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<RegisterBloc, RegisterState>(
        listener: (context,state){
          if (state is RegisterSuccessState) {
            Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(
              builder: (context) => RoutePage()), (Route<dynamic> route) => false
            );
          } else if (state is UsernameFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Username has been taken'))
            );
          } else if (state is EmailFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Email has been taken'))
            );
          } else if (state is RegisterFailState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Network error. Please try again'))
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _signUpText(),
                  SizedBox(height: 12.0,),
                  _usernameField(),
                  _emailField(),
                  _fullnameField(),
                  _dobField(),
                  SizedBox(height: 10.0,),
                  _genderField(),
                  _addressField(),
                  _passwordField(),
                  _confirmpasswordField(),
                  _matchPassword(),
                  SizedBox(height: 10.0,),
                  msg,
                  _signupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpText(){
    return Text("Create your account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
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

  Widget _passwordField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter password';
          }
          if (value.length < 8){
            return 'Password needs to be minimum 8 character';
          }
          return null;
        },
        obscureText: true,
        controller: pwdController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: HexColor("#3c1e08"),),
          labelText: 'Password',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          )
        ),
        onChanged: (value) {
          setState(() {
            password = value;
            print('Confirm password: ${password}');
          });
        },
      ),
    );
  }

  Widget _confirmpasswordField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter password';
          }
          return null;
        },
        obscureText: true,
        focusNode: confirmPasswordFocusNode,
        controller: confirmpwdController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Retype password',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
        onChanged: (value) {
          setState(() {
            confirmpassword = value;
            print('Confirm password: ${confirmpassword}');
          });
        },
      ),
    );
  }

  Widget _matchPassword(){
    if(password.isNotEmpty && confirmpassword.isNotEmpty){
      if (password != confirmpassword){
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Password does not match!', style: TextStyle(color: Colors.red)),
        );
      }
    }
    return Container();
  }

  Widget _signupButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              // success validation
                registerBloc.add(SignUpButtonPressed(
                  username: usernameController.text.trim(),
                  fullname: fullnameController.text.trim(),
                  email: emailController.text.trim(),
                  gender: int.parse(_gender.toString()),
                  password: pwdController.text.trim(),
                  bdayDate: dateController.text.trim(),
                  address: addressController.text,
                  latitude: lat,
                  longitude: long,
              ));
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
            child: Text('SIGN UP', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );
  }

  Widget _genderField() {
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

  Widget _addressField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        readOnly: true,
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
          suffixIcon: IconButton(
            icon: Icon(Icons.add_location),
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapScreen())
              ).then((value) => {
                lat = value['lat'],
                long = value['lng'],
                addressController.text = value['address']

              });
            },
          ),
        ),
        validator: (value){
          if (value == null || value.isEmpty){
            return 'Please enter password';
          }
          return null;
        } ,
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
}
