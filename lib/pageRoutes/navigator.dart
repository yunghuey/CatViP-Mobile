import 'package:CatViP/pages/home_page.dart';
import 'package:CatViP/pages/post/new_post.dart';
import 'package:flutter/material.dart';

class MyNavigator {
  static const String initialRoute = '/home';
  static const String secondRoute = '/newPost';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case secondRoute:
        return MaterialPageRoute(builder: (_) => NewPost());
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
