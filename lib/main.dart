import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_bloc.dart';
import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_state.dart';
import 'package:CatViP/bloc/authentication/login/login_bloc.dart';
import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/bloc/authentication/logout/logout_bloc.dart';
import 'package:CatViP/bloc/authentication/logout/logout_state.dart';
import 'package:CatViP/bloc/authentication/register/register_bloc.dart';
import 'package:CatViP/bloc/authentication/register/register_state.dart';
import 'package:CatViP/bloc/cat/catprofile_bloc.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/bloc/cat/new_cat/createcat_bloc.dart';
import 'package:CatViP/bloc/cat/new_cat/createcat_state.dart';
import 'package:CatViP/bloc/expert/expert_bloc.dart';
import 'package:CatViP/bloc/expert/expert_state.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:CatViP/bloc/user/userprofile_bloc.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:CatViP/pageRoutes/navigator.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/home_page.dart';
import 'package:CatViP/pages/post/new_post.dart';
import 'package:CatViP/pages/splashscreen.dart';
import 'package:CatViP/pages/splashscreen.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:CatViP/repository/expert_repo.dart';
import 'package:CatViP/repository/postType_repo.dart';
import 'package:CatViP/repository/post_repo.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import 'bloc/post/new_post/new_post_bloc.dart';
import 'bloc/post/new_post/new_post_state.dart';

void main() {
  runApp(const MyApp());
  //runApp(const HomePage());
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
        ),
        BlocProvider<GetPostBloc>(
          create: (context) => GetPostBloc(),
        ),
        BlocProvider<NewPostBloc>(
        create: (context) => NewPostBloc(NewPostInitState(), PostRepository(), PostTypeRepository()),
        ),
        BlocProvider<LogoutBloc>(
          create: (context) => LogoutBloc(LogoutInitState(), AuthRepository()),
        ),
        BlocProvider<CreateCatBloc>(
          create: (context) => CreateCatBloc(CreateCatInitState(), CatRepository()),
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(UserProfileInitState(), UserRepository()),
        ),
        BlocProvider<CatProfileBloc>(
            create: (context) => CatProfileBloc(CatProfileInitState(), CatRepository())
        ),
        BlocProvider<ExpertBloc>(
          create: (context) => ExpertBloc(ExpertProfileInitState(), ExpertRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        initialRoute: MyNavigator.initialRoute,
        onGenerateRoute: MyNavigator.generateRoute,
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
                  fontSize: 23,
                )
            ),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: HexColor('#3c1e08')),
              color: HexColor('#3c1e08'),
            )
        ),
        home: Splash(),
      ),

    );
  }
}