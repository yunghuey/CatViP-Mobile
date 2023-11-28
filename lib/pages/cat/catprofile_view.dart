import 'dart:convert';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:CatViP/pages/cat/createcat_view.dart';
import 'package:CatViP/pages/cat/editcat_view.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class CatProfileView extends StatefulWidget {
  final CatModel currentcat;
  final bool fromOwner;

  const CatProfileView({required this.currentcat, Key? key, required this.fromOwner}) : super(key: key);

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
        title: Text(widget.currentcat.name, style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: HexColor("#3c1e08"),),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCatView()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _userDetails(),
            SizedBox(height: 10),
            _catDesc(),
            // _getAllPosts(),
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
          image: widget.currentcat.profileImage != ""
              ? MemoryImage(base64Decode(widget.currentcat.profileImage))  as ImageProvider<Object>
              : AssetImage('assets/profileimage.png'),
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
          Text(widget.currentcat.desc),
        ],
      ),
    );
  }
  Widget _catProfile(){
    DateTime currentDate = DateTime.now();
    DateTime bday = DateTime.parse(widget.currentcat.dob);
    String formatteddate = DateFormat("yyyy-MM-dd").format(bday);
    Duration difference = currentDate.difference(bday);
    int age = difference.inDays;

    return Column(
      children: [
        Text("Age: ${age.toString()} days", style: TextStyle(fontSize: 17)),
        Text("Birthday: ${formatteddate.toString()}", style: TextStyle(fontSize: 15)),

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
