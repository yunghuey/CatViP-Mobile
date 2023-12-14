import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:CatViP/bloc/report%20case/EditCaseReport/editCaseReport_bloc.dart';
import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:CatViP/model/caseReport/caseReportImages.dart';
import 'package:CatViP/pages/report/CaseReportComment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/post/EditPost/editPost_bloc.dart';
import '../../bloc/post/EditPost/editPost_state.dart';
import '../../bloc/report case/EditCaseReport/editCaseReport_event.dart';
import '../../bloc/report case/RevokeCaseReport/revokeCase_bloc.dart';
import '../../bloc/report case/RevokeCaseReport/revokeCase_event.dart';
import '../post/own_post.dart';
import 'getOwnReport.dart';

class UpdateCasesReport extends StatefulWidget {

  final CaseReport caseReport;
  const UpdateCasesReport({super.key, required this.caseReport});

  @override
  State<UpdateCasesReport> createState() => _UpdateCasesReportState();
}

class _UpdateCasesReportState extends State<UpdateCasesReport> {

  late final CaseReport caseReport;
  File? image;
  List<String> base64image = [];
  int id = 0;
  String username = '';
  String profileImage = '';
  String description = '';
  List<CaseReportImage> images = [];
  final _picker = ImagePicker();
  late CompleteCaseBloc completeCaseBloc;
  late RevokeCaseBloc revokeCaseBloc;


  //
  // Future<Uint8List?> _getImageBytes(File imageFile) async {
  //   try {
  //     List<int> imageBytes = await imageFile.readAsBytes();
  //     return Uint8List.fromList(imageBytes);
  //   } catch (e) {
  //     print("Error reading image as bytes: $e");
  //     return null;
  //   }
  // }

  @override
  void initState() {

      caseReport = widget.caseReport;
      images = caseReport.caseReportImages!;
      id = caseReport.id!;
      description = caseReport.description!;
      completeCaseBloc = BlocProvider.of<CompleteCaseBloc>(context);
      revokeCaseBloc = BlocProvider.of<RevokeCaseBloc>(context);

      super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPostBloc, EditPostState>(
      listener: (context, state) {
        if (state is EditPostSuccessState) {
          print('Post edited successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OwnPosts()),
          );
          // Navigator.pop(context, true);

        } else if (state is EditPostFailState) {
          print('Failed to save post');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Case Report",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: HexColor("#ecd9c9"),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  caseReportImage(),
                  SizedBox(height: 4.0),
                  descriptionText(),
                  SizedBox(height: 16.0),
                  Buttons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget caseReportImage() {
    return Container(
      height: images != null && images.isNotEmpty
          ? MediaQuery.of(context).size.width // Set height to screen width if there are images
          : 0, // Set height to 0 if postImages is null or empty
      child: caseReport.caseReportImages != null && caseReport.caseReportImages!.isNotEmpty
          ? PageView.builder(
        itemCount: caseReport.caseReportImages![0].images!.length,
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: Image.memory(
              base64Decode(caseReport.caseReportImages![index].images!),
              fit: BoxFit.cover,
            ),
          );
        },
      )
          : Container(), // Show an empty container if postImages is null or empty
    );
  }

  Widget descriptionText(){
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseReportCommentView(caseReportId: id!),
                ),
              ),
              icon: Icon(
                Icons.comment_bank_outlined,
                color: Colors.black,
                size: 24.0,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4.0,),
            Text(
              description,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
              completeCaseBloc.add(
                  CompleteButtonPressed(
                      postId: id
                  )
              );
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OwnReport()));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Report completed')));
            },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(16),
          ),
          child: Text(
            'Complete',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            revokeCaseBloc.add(
                RevokeCaseButtonPressed(
                    postId: id
                ));
            await Future.delayed(Duration(milliseconds: 500));
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OwnReport()));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report revoked')));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(16),
          ),
          child: Text(
            'Revoke',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }


}

