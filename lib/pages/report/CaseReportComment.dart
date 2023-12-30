import 'dart:async';
import 'dart:convert';
import 'package:CatViP/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_bloc.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_event.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_state.dart';
import '../../model/caseReport/caseReportComments.dart';
import '../home_page.dart';

class CaseReportCommentView extends StatefulWidget {
  final int caseReportId;

  const CaseReportCommentView({Key? key, required this.caseReportId})
      : super(key: key);

  @override
  State<CaseReportCommentView> createState() =>
      _CaseReportCommentsState(caseReportId: caseReportId);
}

class _CaseReportCommentsState extends State<CaseReportCommentView> {
  final GetCaseBloc _caseReportBloc = GetCaseBloc();
  late CaseReportComment caseReportComment;
  final int caseReportId;
  final Widgets func = Widgets();
  //Controllers for input
  TextEditingController commentController = TextEditingController();

  _CaseReportCommentsState({required this.caseReportId});

  @override
  void initState() {
    _caseReportBloc.add(GetCaseReportComments(caseReportId: caseReportId));
    super.initState();
  }

  @override
  void dispose() {
    _caseReportBloc
        .close(); // Make sure to close the bloc when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case Report Comments",
            style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.only(
                bottom: 8.0, left: 5.0, right: 5.0, top: 5.0),
            color: Colors.grey.shade300,
            child: Center(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Type your comment here...",
                  focusColor: HexColor("#3c1e08"),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#3c1e08")),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _caseReportBloc.add(PostCaseReportCommentPressed(
                          description: commentController.text.trim(),
                          caseReportId: caseReportId));
                      commentController.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                  suffixIconColor: HexColor("#3c1e08"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CommentCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: BlocProvider(
        create: (context) => _caseReportBloc,
        child:
            BlocBuilder<GetCaseBloc, GetCaseState>(builder: (context, state) {
          if (state is GetCaseReportCommentError) {
            return Center(
              child: Text(state.error!),
            );
          } else if (state is GetCaseReportCommentInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          } else if (state is GetCaseReportCommentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          } else if (state is GetCaseReportCommentLoaded) {
            List<CaseReportComment> reversedComments =
                List.from(state.caseReportComments.reversed);
            return ListView.builder(
              itemCount: reversedComments.length,
              itemBuilder: (context, index) {
                CaseReportComment caseReportComment = reversedComments[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: caseReportComment.profileImage != ""
                            ? Image.memory(base64Decode(
                                    caseReportComment.profileImage!))
                                .image
                            : AssetImage('assets/profileimage.png'),
                        radius: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: caseReportComment.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                TextSpan(
                                  text: ' ',
                                ),
                                TextSpan(
                                    text: caseReportComment.description,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                func.getFormattedDate(DateTime.parse(
                                    caseReportComment.dateTime!)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
