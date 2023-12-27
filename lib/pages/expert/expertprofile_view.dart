import 'package:CatViP/bloc/expert/expert_bloc.dart';
import 'package:CatViP/bloc/expert/expert_event.dart';
import 'package:CatViP/bloc/expert/expert_state.dart';
import 'package:CatViP/model/expert/expert_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class ExpertProfileView extends StatefulWidget {
  const ExpertProfileView({super.key});

  @override
  State<ExpertProfileView> createState() => _ExpertProfileViewState();
}

class _ExpertProfileViewState extends State<ExpertProfileView> {
  late ExpertBloc expBloc;
  double _opacity = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    expBloc = BlocProvider.of<ExpertBloc>(context);
    expBloc.add(LoadExpertApplicationEvent());
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expert Profile", style: Theme.of(context).textTheme.bodyLarge,),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
          BlocBuilder<ExpertBloc, ExpertState>(
            builder: (context, state){
              if (state is ExpertLoadingState){
                return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
              }
              else if (state is LoadedFormState){
                return AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 2),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 150.0, color: HexColor("#D6B85A")),
                        const SizedBox(height: 15.0),
                        Text(
                          "You are approved to be our expert!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Welcome to join the family",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Thank you for contributing to the community, together let's help the needed cat",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Since ${DateFormat("yyyy-MM-dd").format(DateTime.parse(state.form.applyDateTime))}",
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),


    );
  }
}
