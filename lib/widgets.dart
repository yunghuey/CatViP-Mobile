
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class Widgets extends StatelessWidget {
  const Widgets({super.key, required this.widht});
  final int widht;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: ResizeImage(AssetImage('assets/logo.png'), width: widht),
    );
  }

  void pageRouter() {
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
        ),
      ],
    );
  }
}
