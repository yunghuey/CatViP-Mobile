import 'package:CatViP/pageRoutes/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            margin: EdgeInsets.only(top: 15),
            color: HexColor("#D0D4CA"),
            child: Row(
              children: [
                Container(
                  width: 270,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: HexColor("#3c1e08"),
                      hintText: "Search",
                      focusColor: HexColor("#3c1e08"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(),
      bottomNavigationBar: CustomBottomNavigationBar(),

    );
  }
}
