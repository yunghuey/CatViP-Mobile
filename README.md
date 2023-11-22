# catvip

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


---------------------------------------------
What to do when you want to create a new page with bottom nav bar (thank you wafir!!!!)
1. in navigator.dart
   // declare a route
   static const String fifthRoute = '/profile';
   // put into switch case, UserMenu is the class name of your page
   case fifthRoute:
        return MaterialPageRoute(builder: (_) => UserMenu());
3. declare your page, must add bottomNavigationBar at bottom


import 'package:flutter/material.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});
  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("this is user profile page"),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
