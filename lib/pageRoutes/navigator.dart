import 'package:CatViP/pages/home_page.dart';
import 'package:CatViP/pages/post/new_post.dart';
import 'package:CatViP/pages/search/searchuser_view.dart';
import 'package:CatViP/pages/user/profile_view.dart';
import 'package:flutter/material.dart';

import '../pages/report/newReport.dart';
import '../pages/splashscreen.dart';

class MyNavigator {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String addRoute = '/newPost';
  static const String fourthRoute = '/shopping';
  static const String userRoute = '/profile';
  static const String searchRoute = '/search';
  static const String reportRoute = '/report';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => Splash());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case addRoute:
        return MaterialPageRoute(builder: (_) => NewPost());
       case reportRoute:
         return MaterialPageRoute(builder: (_) => NewReport());
      case userRoute:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case searchRoute:
        return MaterialPageRoute(builder: (_) => SearchView());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Not Found')),
      body: Center(
        child: Text('Route not found!'),
      ),
    );
  }
}
