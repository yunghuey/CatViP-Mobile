import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    retrieveSharedPreference();
    return Scaffold(
      appBar: AppBar(
        //flexibleSpace: _logoImage(),
        title: Text('CatViP'),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text("hello"),
          ],
        ),
      ),
    );
  }


  Future<void> retrieveSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('token'); // Replace 'yourKey' with the key you used when saving the value

    if (savedValue != null) {
      // Use the retrieved value as needed
      print('Retrieved value: $savedValue');
    } else {
      print('Value not found in SharedPreferences');
    }
  }

/*
  Widget pageRouter() {

    final GoRouter _router = GoRouter(
        routes: [
          ShellRoute(
          routes: [
          GoRoute(
              path: '/home',
              builder: (context,state) => HomePage()
           ),
          GoRoute(
              path: '/addPost',
              builder: (context,state) => HomePage()
          ),
          GoRoute(
              path: '/shop',
              builder: (context,state) => HomePage()
          ),
          GoRoute(
              path: '/profile',
              builder: (context,state) => HomePage()
          ),
          ],
            builder: (context, state, child){
            return BottomNavigationBar(child: child);
            }
          ),
        ],
    );

    MaterialApp.router(
        routerConfig: _router
    );

  }

 */


}
