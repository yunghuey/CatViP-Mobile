import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> checkToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Delay the execution of the FutureBuilder for 2000 milliseconds.
    Future.delayed(Duration(milliseconds: 2000),(){
      redirect();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'CatViP',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10.0),
            Container(
              child: Image.asset('assets/logo.png', width: 250.0),
              alignment: Alignment.center,
            ),
            SizedBox(height: 10.0),
            Text(
              'Angles with whiskers',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 5.0),
            CircularProgressIndicator(color:  HexColor("#3c1e08")),

          ],
        ),
      ),
    );
  }

  Future<void> redirect() async {
    bool hasToken = await checkToken();
    if (hasToken) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => HomePage()),
          (Route<dynamic> route) => false
      );
    } else {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => LoginView()),
              (Route<dynamic> route) => false
      );
    }
  }
}
