import 'package:CatViP/bloc/authentication/login/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login/login_event.dart';
import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/pages/authentication/forgotpwd_view.dart';
import 'package:CatViP/pages/authentication/signup_view.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


class LoginView extends StatefulWidget {

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // controller for input
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  // declare attribute
  late AuthBloc authBloc;

  @override
  void initState() {
    // TODO: implement initState
    // initialize
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final msg = BlocBuilder<AuthBloc, AuthState>(
      builder: (context,state){
        if(state is LoginErrorState){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(state.message, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),),
          );
        } else if (state is LoginLoadingState){
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator(color: HexColor("#3c1e08"),)),
          );
        } else{
          return Container();
        }
      }
    );

    return Scaffold(
      body:
      BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is UserLoginSuccessState){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => const HomePage()), (Route<dynamic> route) => false
            );
          }
        },
        child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  //  it will adjust the space on up and down
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _logoImage(),
                    _logoText(),
                    _usernameField(),
                    const SizedBox(height: 10.0),
                    _passwordField(),
                    _forgotPassword(),
                    msg,
                    _loginButton(),
                    _signUpText(),
                  ],
                ),
              ),
            ),
        ),
      ),
      );
  }

  Widget _signUpText(){
    return Container(
        child: TextButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpView(),));
          },
          child: Text('Don\'t have an account? Sign up here', style: Theme.of(context).textTheme.bodyMedium,),
        )
    );
  }

  Widget _forgotPassword(){
    return Container(
      margin: EdgeInsets.only(top:10.0),
      child:  Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: (){
            print("forgot password");
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPwd()));
          } ,
          child: Text('Forgot password', style: Theme.of(context).textTheme.bodyMedium,),
        )
      ),
    );
  }

  Widget _logoText(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('CatViP', style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Widget _logoImage(){
    return const Image(
      image: ResizeImage(AssetImage('assets/logo.png'), width: 170),
    );
  }

  Widget _usernameField(){
      return TextFormField(
        controller: usernameController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.person, color: HexColor("#3c1e08"),),
          hintText: 'Username',
          focusColor: HexColor("#3c1e08"),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#3c1e08"), width: 1.0,),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4"), width: 1.0,),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
  }

  Widget _passwordField(){
      return TextFormField(
        obscureText: true,
        controller: pwdController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: HexColor("#3c1e08"),),
          hintText: 'Password',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#3c1e08"), width: 1.0,),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4"), width: 1.0,),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
            onPressed: () {
                print(usernameController.text);
                print(pwdController.text);
                if (usernameController.text != "" && pwdController.text != "" ){
                  authBloc.add(LoginButtonPressed(
                    username: usernameController.text,
                    password: pwdController.text,
                  ));
                } else {
                  authBloc.add(EmptyField());
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
              child: Text('SIGN IN', style: TextStyle(fontSize: 16),),
            ),
        ),
      ),
    );
  }
}
