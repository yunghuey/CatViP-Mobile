import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:CatViP/pages/cat/createcat_view.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CatProfileView extends StatefulWidget {
  const CatProfileView({super.key});

  @override
  State<CatProfileView> createState() => _CatProfileViewState();
}

class _CatProfileViewState extends State<CatProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          _userDetails(),
          SizedBox(height: 10),
          _catDesc(),
          _getAllPosts(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),

    );
  }

  Widget _profileImage(){
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape:BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/Dinosaur.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _catDesc(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cute meow meow"),
        ],
      ),
    );
  }
  Widget _catProfile(){
    return Column(
      children: [
        Text("Tabby", style: TextStyle(fontSize: 20)),
        Text("Age 2", style: TextStyle(fontSize: 17)),
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
                _catProfile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAllPosts(){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 30,
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
