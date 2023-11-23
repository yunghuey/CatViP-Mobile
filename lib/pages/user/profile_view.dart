import 'package:CatViP/bloc/authentication/logout/logout_bloc.dart';
import 'package:CatViP/bloc/authentication/logout/logout_event.dart';
import 'package:CatViP/bloc/authentication/logout/logout_state.dart';
import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:CatViP/pages/authentication/login_view.dart';
import 'package:CatViP/pages/cat/catprofile_view.dart';
import 'package:CatViP/pages/cat/createcat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
          title: Text('Username', style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: HexColor("#3c1e08"),),
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context){
                      return _menu();
                    }
                ) ; //showModalbottomsheet
              },
            )
          ],
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
        child:  Column(
          children: [
            _userDetails(),
            _buttons(),
            _getAllCats(),
            _getAllPosts(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _profileImage(){
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape:BoxShape.circle,
          image: DecorationImage(
            image: ResizeImage(AssetImage('assets/Dinosaur.png'), width: 170),
            fit: BoxFit.cover,
          ),
        ),
      );
  }

  Widget _menu(){
    return Container(
      color: HexColor("#ecd9c9"),
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit profile"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Register Cat"),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CreateCatView(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.grade_rounded),
            title: Text("Apply for expert"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: (){
              logoutbloc.add(LogoutButtonPressed());
            },
          )
        ],
      )

    );
  }

  Widget _followers(){
      return Column(
        children: [
          Text('154', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          Text("Followers"),
        ],
      );
  }

  Widget _following(){
    return Column(
      children: [
        Text('184', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Following"),
      ],
    );
  }

  Widget _tipsPost(){
    return Column(
      children: [
        Text('5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Tips"),
      ],
    );
  }

  Widget _userDetails(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _profileImage(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _followers(),
                _following(),
                _tipsPost(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text("Follow"),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: HexColor("#3c1e08"), width: 1)),
                      backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                      foregroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                    ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text("Message"),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color: HexColor("#3c1e08"), width: 1)),
                      backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                      foregroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                    ),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAllCats(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        height: 105,
        child: ListView.builder(
          itemCount: 7,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => CatProfileView(),));

                        },
                        child: CircleAvatar(
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage:  ResizeImage(AssetImage('assets/Dinosaur.png'), width: 170),
                          ),
                          backgroundColor: HexColor("#3c1e08"),
                          radius: 35,
                        ),
                      ),
                    ),
                    Text("Tabby"),
                  ],
                ),
              ],
            );
          },

        ),
      ),
    );
  }

  Widget _getAllPosts(){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                color: Colors.blue,
              )
            );
          },
        ),
      ),
    );
  }
}
