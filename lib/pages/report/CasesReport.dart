import 'dart:convert';
import 'package:CatViP/bloc/post/ReportPost/reportPost_bloc.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_event.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_state.dart';
import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_bloc.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_event.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_state.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';
import '../../widgets/widgets.dart';
import 'CaseReportComment.dart';



class CaseReports extends StatefulWidget {
  const CaseReports({super.key});

  @override
  State<CaseReports> createState() => _CasesReportsState();

}

class _CasesReportsState extends State<CaseReports> {
  final GetCaseBloc caseBloc = GetCaseBloc();
  late ReportPostBloc reportBloc;
  int? selectedPostIndex;
  late final int? postId;
  final Widgets func = Widgets();
  TextEditingController reportController = TextEditingController();
  Set<int> reportedPostIds = {};

  void _removeExpense(int index) async{
/*
    Expense exp = Expense.withId(expenses[index].id, 0.0, '', '');

    if(await exp.delete()) {
      totalAmount -= expenses[index].amount;
      setState(() {
        expenses.removeAt(index);
        totalAmountController.text = totalAmount.toString();
      });
    }*/

  }


  void _editExpense(int index) {
    /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          expense: expenses[index],
          onSave: (editedExpense) {
            print(editedExpense.desc);
            setState(() {
              totalAmount +=
                  editedExpense.amount -
                      expenses[index].amount;
              expenses[index] = editedExpense;
              totalAmountController.text = totalAmount.toString();
            });
          },
        ),
      ),
    );*/
  }


  @override
  void initState() {
    // TODO: implement initState
    reportBloc = BlocProvider.of<ReportPostBloc>(context);
    caseBloc.add(GetCaseList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    retrieveSharedPreference();
    return BlocProvider(
      create: (context) => caseBloc,
      child: Scaffold(
        appBar: AppBar(
          //flexibleSpace: _logoImage(),
          title: Text('Case Reports',style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          // automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.messenger_outline, color: HexColor("#3c1e08"),),
              color: Colors.white,
            ),
          ],
        ),
        body: _buildListUser(),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Future<String> getMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String message = prefs.getString('message') ?? '';

    return message;
  }

  Widget _buildListUser() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocProvider(
        create: (context) => caseBloc,
        /*child: BlocListener<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // Handle state changes here
            if (state is ReportPostSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your report has been submitted")),
              );
              *//*  setState(() {
              reportedPostIds.add(post.id!);
            });*//*
            } else if (state is ReportPostFailState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("You can't report your own post")),
              );
            }
          },*/
          child: BlocBuilder<GetCaseBloc, GetCaseState>(
            builder: (context, state) {
              if (state is GetCaseError) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (state is GetCaseInitial || state is GetCaseLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetCaseLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.caseList.length,
                        itemBuilder: (context, index) {
                          final CaseReport caseReport = state.caseList[index];
                          if (reportedPostIds.contains(caseReport.id)) {
                            return Container(); // Skip rendering this post
                          }
                          return Card(
                            color: HexColor("#ecd9c9"),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: caseReport.profileImage != null
                                              ? Image.memory(base64Decode(caseReport.profileImage!)).image
                                              : AssetImage('assets/profileimage.png'),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  caseReport.username!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Report"),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller: reportController,
                                                        decoration: InputDecoration(
                                                          hintText: "Enter your report...",
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      TextButton(
                                                        onPressed: () async {
                                                          // Handle the report logic here
                                                          String reportText = reportController.text;
                                                          reportBloc.add(
                                                              ReportButtonPressed(
                                                                postId: caseReport.id!,
                                                                description: reportText,
                                                              )
                                                          );

                                                          // Wait for the completion of the ReportButtonPressed event
                                                          await reportBloc.stream.firstWhere((state) =>
                                                          state is ReportPostSuccessState || state is ReportPostFailState,
                                                          );

                                                          if (!(reportBloc.state is ReportPostFailState)) {
                                                            setState(() {
                                                              reportedPostIds.add(caseReport.id!);
                                                              reportController.clear();
                                                            });
                                                          }
                                                          print("Report: $reportText");

                                                          reportController.clear();
                                                          await Future.delayed(Duration(milliseconds: 100));
                                                          // Close the dialog
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Report"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        ),
                                      ],
                                    ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: ' ',
                                          ),
                                          TextSpan(
                                            text: caseReport.description.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Container(
                                    height: caseReport.caseReportImages != null && caseReport.caseReportImages!.isNotEmpty
                                        ? MediaQuery.of(context).size.width // Set height to screen width if there are images
                                        : 0, // Set height to 0 if postImages is null or empty
                                    child: caseReport.caseReportImages != null && caseReport.caseReportImages!.isNotEmpty
                                        ? PageView.builder(
                                      itemCount: caseReport.caseReportImages![index].images!.length,
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
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CaseReportCommentView(caseReportId: caseReport.id!),
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                       /* Text(
                                          "${post.likeCount.toString()} likes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Comments(postId: post.id!),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: post.commentCount! > 0
                                                ? Text(
                                              'View all ${post.commentCount} comments',
                                              style: const TextStyle(fontSize: 14, color: Colors.black),
                                            )
                                                : SizedBox.shrink(),
                                          ),
                                        ),*/
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                            func.getFormattedDate(caseReport.dateTime!),
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
     // ),
    );
  }



  Future<void> retrieveSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('token'); // Replace 'yourKey' with the key you used when saving the value

    if (savedValue != null) {
      // Use the retrieved value as needed
      print('Retrieved value: $savedValue');
    } else {
      print('Value not found in SharedPreferences');
    }
  }

}

