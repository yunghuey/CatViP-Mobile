import 'dart:convert';
import 'dart:typed_data';

import 'package:CatViP/bloc/expert/expert_bloc.dart';
import 'package:CatViP/bloc/expert/expert_event.dart';
import 'package:CatViP/bloc/expert/expert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExpertFormView extends StatefulWidget {
  const ExpertFormView({super.key});

  @override
  State<ExpertFormView> createState() => _ExpertFormViewState();
}

class _ExpertFormViewState extends State<ExpertFormView> {
  TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late ExpertBloc expBloc;
  File? selectedFile;
  late String filename;
  late String _pdfContent = "";
  late var msg = Container();

  @override
  void initState() {
    // TODO: implement initState
    expBloc = BlocProvider.of<ExpertBloc>(context);
    super.initState();
  }

  Future<void> _uploadAndConvert() async {
    if (selectedFile != null) {
      // Read PDF file content as bytes
      Uint8List bytes = await selectedFile!.readAsBytes();
      // Convert bytes to base64 string
      String base64String = base64Encode(bytes);
      setState(() {
        _pdfContent = base64String;
      });
    } else {
      print("empty file selecteed");
    }
  }

  late final loading = BlocBuilder<ExpertBloc, ExpertState>(
      builder: (context, state){
        if (state is ExpertLoadingState){
          return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
        }
        return Container();
      });
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
      BlocListener<ExpertBloc,ExpertState>(
        listener: (context, state){
          if (state is AppliedSuccessState){
            Navigator.popUntil(context, (route) => Navigator.of(context).canPop());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content:
              Text("Your application has been submitted."
                  " It needs a two working days to process."))
            );
          } else if (state is AppliedFailState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message))
            );
          }
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(5.0),
          child: Form(
              child: Column(
                children: [
                  _descTextField(),
                  SizedBox(height: 10),
                  _docField(),
                  msg,
                  loading,
                  _submitButton(),
                ],
              )
          ),
        ),
      )

    );
  }

  Widget _descTextField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: descController,
        maxLines: 3,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.speaker_notes_outlined, color: HexColor("#3c1e08"),),
          labelText: 'Talk more about your expertise',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter your description';
          }
          return null;
        },
      ),
    );
  }

  Widget _docField() {
    return Column(
      children: [
        Text("Upload your relevant document. Format must be in pdf"),
        TextButton(
          child: Text("Choose file", style: TextStyle(color: HexColor("#3c1e08")),),
          onPressed: () {
            uploadPdf();
          },
        ),
        if (selectedFile != null) Text("Selected File: $filename"),
      ],
    );
  }

  Widget _submitButton(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 300.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: ()  {
            // if(_formKey.currentState!.validate()) {}
            if (descController.text.isNotEmpty){
              if (_pdfContent.isNotEmpty){
              //   bloc
                print("pdf success: ${_pdfContent}");
                expBloc.add(ApplyButtonPressed(desc: descController.text, document: _pdfContent));
              } else {
                setState(() {
                  msg = Container(child: Text("Please upload your document", style: TextStyle(color: Colors.red),));
                });
              }
            } else{
              setState(() {
                msg = Container(child: Text("Fill up your description", style: TextStyle(color: Colors.red),));
              });
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
            ),
            backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),

          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('APPLY', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );

  }

  Future<void> uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      if (selectedFile != null){
        // read PDF file content as byte
        Uint8List bytes = await selectedFile!.readAsBytes();
        String pdfBase64 = base64Encode(bytes);
        setState(() {
          _pdfContent = pdfBase64;
          print("pdfContent is given value $_pdfContent");
          msg = Container();
        });
      }
      setState(() {
        selectedFile = File(result.files.single.path ?? "");
        filename = selectedFile!.path.split('/').last;
      });
    }
    else {
      print("result is null");
    }
    _uploadAndConvert();
    print("done with uploadPdf()");
  }

}
