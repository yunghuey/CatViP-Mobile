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
import 'package:CatViP/bloc/post/OwnCats/ownCats_bloc.dart';
import 'package:CatViP/bloc/user/userprofile_bloc.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:CatViP/pageRoutes/navigator.dart';
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
import 'bloc/post/DeletePost/deletePost_bloc.dart';
import 'bloc/post/DeletePost/deletePost_state.dart';
import 'bloc/post/EditPost/editPost_bloc.dart';
import 'bloc/post/EditPost/editPost_state.dart';
import 'bloc/post/OwnCats/ownCats_state.dart';
import 'bloc/post/new_post/new_post_bloc.dart';
import 'bloc/post/new_post/new_post_state.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize("2c9ce8b1-a075-4864-83a3-009c8497310e");
  OneSignal.login("12345");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

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
        ),
        BlocProvider<GetPostBloc>(
          create: (context) => GetPostBloc(),
        ),
        BlocProvider<NewPostBloc>(
        create: (context) => NewPostBloc(NewPostInitState(), PostRepository(), PostTypeRepository(), CatRepository()),
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
        BlocProvider<OwnCatsBloc>(
          create: (context) => OwnCatsBloc(GetOwnCatsInitial(), CatRepository()),
        ),
        BlocProvider<EditPostBloc>(
          create: (context) => EditPostBloc(EditPostInitState(), PostRepository()),
        ),
        BlocProvider<DeletePostBloc>(
          create: (context) => DeletePostBloc(DeletePostInitState(), PostRepository()),
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