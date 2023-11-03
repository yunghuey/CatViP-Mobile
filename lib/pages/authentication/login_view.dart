import 'package:CatViP/bloc/authentication/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login_event.dart';
import 'package:CatViP/bloc/authentication/login_state.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          return Text(state.message);
        } else if (state is LoginLoadingState){
          return Center(child: CircularProgressIndicator());
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage())
            );
          }
        },
        child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  //  it will adjust the space on up and down
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _logoImage(),
                    _loginText(),
                    _usernameField(),
                    _passwordField(),
                    msg,
                    _loginButton(),
                  ],
                ),
              ),
            ),
          ),
      ),
      );
  }

  Widget _loginText(){
    return const Text('Login', style: TextStyle(fontSize: 35),);
  }

  Widget _logoImage(){
    return const Image(
      image: ResizeImage(AssetImage('assets/logo.png'), width: 170),
    );
  }

  Widget _usernameField(){
      return TextFormField(
        autofocus: true,
        controller: usernameController,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
      );
  }

  Widget _passwordField(){
      return TextFormField(
        obscureText: true,
        controller: pwdController,
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: 'Password',
        ),
      );
  }

  Widget _loginButton() {
    return ElevatedButton(
        onPressed: () {
            print(usernameController.text);
            print(pwdController.text);
            authBloc.add(LoginButtonPressed(
                    username: usernameController.text,
                    password: pwdController.text,
            ));
        },
        child: const Text('Sign In')
    );
  }
}
