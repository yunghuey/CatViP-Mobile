import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_bloc.dart';
import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_event.dart';
import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_state.dart';
import 'package:CatViP/pages/SnackBarDesign.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPwd extends StatefulWidget {
  const ForgotPwd({super.key});

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  late ForgotPwdBloc pwdBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pwdBloc = BlocProvider.of<ForgotPwdBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    final msg = BlocBuilder<ForgotPwdBloc, ForgotPwdState>(
      builder: (context, state){
        if (state is SendingLoadingState){
          return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
        } else if (state is SentEmailSuccess){
          return Text('A verification email has been sent, please check your email',
            style: TextStyle(fontWeight: FontWeight.bold),);
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
      BlocListener<ForgotPwdBloc, ForgotPwdState>(
        listener: (content, state){
           if (state is SentEmailFail){
             final snackBar = SnackBarDesign.customSnackBar('Email is invalid. Please try again');
             ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child:  Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _forgotText(),
                  SizedBox(height: 10.0),
                  _instructionText(),
                  SizedBox(height: 5.0),
                  _emailField(),
                  SizedBox(height: 10.0,),
                  msg,
                  _submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _forgotText(){
    return Text("Forgot password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
  }
  
  Widget _instructionText(){
    return Text("Enter email address",  style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),);
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
  
  Widget _submitButton(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              // success validation
              print(emailController.text.trim());
              pwdBloc.add(SendButtonPressed(email: emailController.text.trim()));
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
            child: Text('SEND', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );
  }

}
