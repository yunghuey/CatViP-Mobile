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
  List<Map<String, String>> listPost = [
    {
      'images': 'assets/sunset.jpg',
    },
    {
      'images': 'assets/hk2.jpg',
    },
    {
      'images': 'assets/sunset.jpg'
    },
    {
      'images': 'assets/mountain.jpg'
    },
    {
      'images': 'assets/hk1.jpg',
    },
    {
      'images': 'assets/hk2.jpg',
    },
    {
      'images': 'assets/sunset.jpg'
    },
    {
      'images': 'assets/mountain.jpg'
    },
    {
      'images': 'assets/hk1.jpg',
    },
    {
      'images': 'assets/hk2.jpg',
    },
    {
      'images': 'assets/sunset.jpg'
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _userDetails(),
            SizedBox(height: 10),
            _catDesc(),
            _getAllPosts(),
          ],
        ),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1/1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index){
        final post = listPost[index];

        return GestureDetector(
          onTap: (){
            //   handle one image
            //   new page
          },
          child: Container(
            color: Colors.grey,
            child: Image.asset(
              post['images']!,
              fit: BoxFit.cover,),
          ),
        );
      },
      itemCount: listPost.length,
    );
  }
}
