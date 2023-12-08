import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String btntext = "Follow";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text("username", style: Theme.of(context).textTheme.bodyLarge,),
      ),
      body: SingleChildScrollView(
        child: Column(
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
          color: Colors.white,
          shape:BoxShape.circle,
          image: DecorationImage(
            image:
            // user.profileImage != ""
            //     ? MemoryImage(base64Decode(user!.profileImage!)) as ImageProvider<Object> :
            AssetImage('assets/profileimage.png'),
            fit: BoxFit.cover,
          ),
        )
    );
  }

  Widget _followers(){
    return Column(
      children: [
        Text("100", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Followers"),
      ],
    );
  }

  Widget _following(){
    return Column(
      children: [
        Text(200.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Text("Following"),
      ],
    );
  }

  Widget _tipsPost(){
    // if (user!.isExpert == true){
      return Column(
        children: [
          Text("10", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          Text("Tips"),
        ],
      );
    // } else {
    //   return Column();
    // }
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
                  onPressed: (){
                   setState(() {
                     btntext = (btntext == "Follow") ? "Unfollow" : "Follow";
                   });
                  },
                  child: Text(btntext),
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
        height: 120,
        child: ListView.builder(
          itemCount:5,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            // final cat = cats[index];
            return Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => CatProfileView(currentcat: cats[index],fromOwner: true,)))
                          //     .then((value) {
                          //   catBloc.add(StartLoadCat());
                          //   postBloc.add(StartLoadOwnPost());
                          // });
                        },
                        child: CircleAvatar(
                          backgroundColor: HexColor("#3c1e08"),
                          radius: 40,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage:
                            // cats[index].profileImage != ""
                            //     ? MemoryImage(base64Decode(cats[index].profileImage))  as ImageProvider<Object>:
            AssetImage('assets/profileimage.png'),
                          ),
                        ),
                      ),
                    ),
                    Text("Meow"),
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
        // final post = listPost[index];

        return GestureDetector(
          onTap: (){
            //   handle one image
            //   new page
            //   wait for wafir's code
            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(currentPost: post)));
          },
          child: Container(
            color: Colors.grey,
            // child: post.postImages != null && post.postImages!.isNotEmpty ?
            // Image(image: MemoryImage(base64Decode(post.postImages![0].image!)),fit: BoxFit.cover,) : Container(),
          ),
        );
      },
      itemCount: 10,
    );
  }


}
