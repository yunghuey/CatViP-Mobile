import 'package:CatViP/bloc/authentication/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login_state.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'CatViP';
    return BlocProvider(
        create: (context) => AuthBloc(LoginInitState(), AuthRepository()),
        child: MaterialApp(
          title: title,
          theme: ThemeData(
            scaffoldBackgroundColor: HexColor("#ecd9c9"),
            fontFamily: 'Times New Roman'
          ),
          home: LoginView(),
        )
    );

    // return MaterialApp(
    //   routes: {
    //     '/': (context) => UI_classname(),
    //     '/user' : (context) => profile_classname(),
    //   },
    // );
  }
}
