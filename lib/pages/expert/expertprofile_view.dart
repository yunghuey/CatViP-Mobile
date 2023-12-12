import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ExpertProfileView extends StatefulWidget {
  const ExpertProfileView({super.key});

  @override
  State<ExpertProfileView> createState() => _ExpertProfileViewState();
}

class _ExpertProfileViewState extends State<ExpertProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expert Profile", style: Theme.of(context).textTheme.bodyLarge,),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.star,size: 60.0),
              SizedBox(height: 15.0),
              Text("You are approved to be our expert!",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,),
              SizedBox(height: 15.0),
              Text("Welcome to join the family",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,),
              SizedBox(height: 15.0),
              Text("Thank you for contributing to the community, together let's help the needed cat",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
