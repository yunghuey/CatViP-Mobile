import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/pages/RoutePage.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/bloc/authentication/login/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login/login_event.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthBloc authBloc;

  Future<String> checkToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    // Delay the execution of the FutureBuilder for 2000 milliseconds.
    Future.delayed(Duration(milliseconds: 1000),(){
      redirect();
    });
  }

  Future<void> redirect() async {
    String hasToken = await checkToken();
    if (hasToken != "") {
      authBloc.add(GetRefreshToken());
    } else {
      authBloc.add(GetLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is RefreshTokenSuccess){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => RoutePage()),
                    (Route<dynamic> route) => false
            );
          } else if (state is RefreshTokenFail || state is LoginInitState){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => LoginView()),
                    (Route<dynamic> route) => false
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CatViP',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10.0),
              Container(
                child: Image.asset('assets/logo.png', width: 200.0),
                alignment: Alignment.center,
              ),
              SizedBox(height: 10.0),
              Text('Angles with whiskers',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 5.0),
              CircularProgressIndicator(color:  HexColor("#3c1e08")),

            ],
          ),
        ),
      ),
    );
  }
}
