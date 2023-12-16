import 'dart:convert';
import 'dart:io';

import 'package:CatViP/bloc/expert/expert_bloc.dart';
import 'package:CatViP/bloc/expert/expert_event.dart';
import 'package:CatViP/bloc/expert/expert_state.dart';
import 'package:CatViP/model/expert/expert_model.dart';
import 'package:CatViP/pages/expert/expertform_view.dart';
import 'package:CatViP/pages/user/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';


class ExpertCheckView extends StatefulWidget {
  int formstatus;

  ExpertCheckView({
    required this.formstatus,
    Key? key
  }):super(key:key);
  @override
  State<ExpertCheckView> createState() => _ExpertCheckViewState();
}

class _ExpertCheckViewState extends State<ExpertCheckView> {
  late int formstatus;
  late ExpertBloc expBloc;
  late ExpertApplyModel formList;
  late String btnText = "Revoke Application";
  @override
  void initState() {
    // TODO: implement initState
    expBloc = BlocProvider.of<ExpertBloc>(context);
    expBloc.add(LoadExpertApplicationEvent());
    formstatus = widget.formstatus;
    if (formstatus == 2){
      btnText = "Reapply";
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expert Application", style: Theme.of(context).textTheme.bodyLarge,),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<ExpertBloc, ExpertState>(
        listener: (context, state){
          if (state is RevokeFailState){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileView()));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Revoke failed. Please try again later"))
            );
          } else if (state is RevokeSuccessState){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileView()));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Application has been removed"))
            );
          }
        },
        child: BlocBuilder<ExpertBloc, ExpertState>(
            builder: (context, state){
              if (state is ExpertLoadingState){
                return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
              } else if (state is LoadedFormState){
                formList = state.form;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _applicationList(),
                    ],
                  ),
                );
              }
              return Container(child: Text("No application retrieved"),);
            }
        ),
      )


    );
  }

  Widget _applicationList(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (context, index){
            final form = formList;
            return Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status : ${form.status}"),
                  Text("Application Date: ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(form.applyDateTime))}"),
                  Row(
                    children: [
                      Text("Document: "),
                      TextButton(onPressed: (){
                        createPdf(form.document);
                      }, child: Text("View document",
                          style: TextStyle(
                            color: HexColor("#3c1e08"),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      )
                    ],
                  ),
                  Text("Description: ${form.description}"),
                  if(form.status == "Rejected") Text("Rejected reason: ${form.rejectedReason}"),
                  ElevatedButton(
                      onPressed: (){
                        int formId = form.id;
                        if (btnText == "Reapply"){
                          reapplyApplication();
                        } else{
                          removeApplication(formId);
                        }
                      },
                      child: Text(btnText,  style: TextStyle(color: HexColor("#3c1e08"))),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#ecd9c9"),),
                        side: MaterialStateProperty.all(BorderSide(width: 2.0, color: HexColor("#3c1e08"),),),
                      ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  void reapplyApplication(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Reapply application'),
        content: const Text('Are you sure to reapply?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpertFormView()));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void removeApplication(int formId){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Revoke application'),
        content: const Text('Are you sure to remove this application?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              expBloc.add(RevokeButtonPressed(formid: formId));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
  Future<void> createPdf(String base64String) async {
    try{
      print(base64String);
      var bytes = base64Decode(base64String);
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/expert.pdf");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      debugPrint("${output.path}/expert.pdf");
      await OpenFilex.open("${output.path}/expert.pdf");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your file is corrupted and unable to read. Please revoke the application and apply again."))
      );
    }

  }
}
