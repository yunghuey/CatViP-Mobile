import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_bloc.dart';
import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_state.dart';
import 'package:CatViP/bloc/authentication/login/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/bloc/authentication/register/register_bloc.dart';
import 'package:CatViP/bloc/authentication/register/register_state.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/splashscreen.dart';
import 'package:CatViP/pages/splashscreen.dart';
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
    return MultiBlocProvider(
      // whichever page that declare BlocProvider need to initialize here
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(LoginInitState(), AuthRepository()),
        ),
        //  need to
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(RegisterInitState(), AuthRepository()),
        ),
        BlocProvider<ForgotPwdBloc>(
          create: (context) => ForgotPwdBloc(PasswordInitState(), AuthRepository()),
        )
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
              scaffoldBackgroundColor: HexColor("#ecd9c9"),
              fontFamily: 'Times New Roman',
              textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    color: HexColor("#3c1e08"),
                    fontSize: 13,
                  ),
                  bodyLarge: TextStyle(
                    color: HexColor("#3c1e08"),
                    fontSize: 26,
                  )
              ),
              appBarTheme: AppBarTheme(

                iconTheme: IconThemeData(color: HexColor('#3c1e08')),
                color: HexColor('#3c1e08'),
              )
          ),
          home: Splash(),
          //    need to change into splash screen
        )
    );
  }
}
// dont delete by yung huey
// return MaterialApp(
//   routes: {
//     '/': (context) => UI_classname(),
//     '/user' : (context) => profile_classname(),
//   },
// );