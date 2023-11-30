import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ExpertIntro extends StatelessWidget {
  const ExpertIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expert", style: Theme.of(context).textTheme.bodyLarge,),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                    width: 250.0,
                    height: 250.0,
                    child: Image.asset('assets/expertIcon.jpg')
                ),
                const SizedBox(height: 15.0),
                const Text("To be an expert", style: TextStyle(fontSize: 25)),
                const SizedBox(height: 15.0),
                const Text("Wonder about your task?", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 15.0),
                const Center(
                  child: Text("To become an expert, you can share the tips for cat owner daily!",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const Center(
                  child: const Text("It is easy to apply, just show out your qualifications that you are proud off!",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){

                    },
                    child: Text(
                        "Apply Now",
                        style: TextStyle(fontSize: 15, color: HexColor("#3c1e08"),),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0),)
                      ),
                      backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9")),
                    ),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }
}
