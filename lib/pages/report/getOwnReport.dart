import 'dart:convert';
import 'package:CatViP/bloc/post/ReportPost/reportPost_bloc.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_event.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_state.dart';
import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:CatViP/pages/post/comment.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_bloc.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_event.dart';
import 'package:CatViP/bloc/post/GetPost/getPost_state.dart';
import 'package:CatViP/pages/report/newReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_bloc.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_event.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_state.dart';
import '../../model/post/post.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';
import '../../widgets/widgets.dart';



class OwnReport extends StatefulWidget {
  const OwnReport({super.key});

  @override
  State<OwnReport> createState() => _OwnReportState();

}

class _OwnReportState extends State<OwnReport> {
  final GetCaseBloc caseBloc = GetCaseBloc();
  late ReportPostBloc reportBloc;
  int? selectedPostIndex;
  late final int? postId;
  final Widgets func = Widgets();
  bool isFavorite = false;
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  bool hasBeenLiked = false;
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
    caseBloc.add(StartLoadOwnCase());
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
          title: Text('My Cases',style: Theme.of(context).textTheme.bodyLarge),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
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
        child: BlocListener<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // Handle state changes here
            if (state is ReportPostSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your report has been submitted")),
              );
            } else if (state is ReportPostFailState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("You can't report your own post")),
              );
            }
          },
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
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: state.caseList.length,
                      itemBuilder: (context, index) {
                        final CaseReport caseReport = state.caseList[index];
                        if (reportedPostIds.contains(caseReport.id)) {
                          return Container(); // Skip rendering this post
                        }
                        return Dismissible(
                          key: Key(caseReport.id.toString()),
                          background: Container(
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Item dismissed')),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(caseReport.description!),
                              subtitle: Row(
                                children: [
                                  Text('Address: ${caseReport.address!}'),
                                  const Spacer(),
                                  Text(
                                    'Date: ${func.getFormattedDate(caseReport.dateTime!)}',
                                  )
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete button press
                                },
                              ),
                              onLongPress: () {
                                // Handle long press
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        backgroundColor: Colors.brown,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => NewReport())
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                );
              } else {
                return  Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.brown,
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewReport())
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
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

