import 'package:CatViP/bloc/authentication/logout/logout_bloc.dart';
import 'package:CatViP/bloc/authentication/logout/logout_event.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/cat/createcat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/authentication/logout/logout_state.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});
  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {

  late LogoutBloc logoutbloc;
  @override
  void initState() {
    super.initState();
    logoutbloc = BlocProvider.of<LogoutBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body:
      BlocListener<LogoutBloc, LogoutState>(
        listener: (context,state){
          if (state is LogoutSuccessState){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => LoginView()), (Route<dynamic> route) => false
            );
          }
        },
        child:  Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userImage(),
              _userNameText(),
              _menuList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _userImage() {
    return Image(
      image: ResizeImage(AssetImage('assets/Dinosaur.png'), width: 170),
    );
  }

  Widget _userNameText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Daniel", style: TextStyle(fontSize: 15),),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
  }

  Widget _menuList() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(top: 4),
        children: [
          _buildButton('My Profile', () {
            // Handle My Profile button click
          }),
          _buildButton('Register My Cat', () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => CreateCatView(),));
          }),
          _buildButton('View All Cat', () {
            // Handle View All Cat button click
          }),
          _buildButton('Apply for Expert', () {
            // Handle Apply for Expert button click
          }),
          _buildButton('Log Out', () {
            logoutbloc.add(LogoutButtonPressed());
          }),
        ],
      ),
    );
  }
}
