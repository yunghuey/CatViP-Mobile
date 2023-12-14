import 'package:CatViP/bloc/post/ReportPost/reportPost_bloc.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_state.dart';
import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:CatViP/pages/report/newReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_bloc.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_event.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_state.dart';
import '../../pageRoutes/bottom_navigation_bar.dart';
import '../../widgets/widgets.dart';
import 'UpdateCasesReport.dart';



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
  final List<CaseReport> caseReports = [];



  void _editReport(CaseReport caseReport) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCasesReport(
          caseReport: caseReport
        ),
      ),
    );
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GetCaseBloc>.value(value: caseBloc),
          BlocProvider<ReportPostBloc>(
            create: (context) => reportBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ReportPostBloc, ReportPostState>(
              listener: (context, state) {
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
              child: Container(), // You can leave this empty or use it for UI if needed
            ),
            // Add BlocListener for CaseReportBloc here if needed
          ],
          child: BlocBuilder<GetCaseBloc, GetCaseState>(
            builder: (context, state) {
              if (state is GetCaseError) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (state is GetCaseInitial || state is GetCaseLoading) {
                return Center(
                  child: CircularProgressIndicator(color:  HexColor("#3c1e08"),),
                );
              } else if (state is GetCaseLoaded) {
                List<CaseReport> caseList = state.caseList;
                return listCase(caseList);
              } else {
                return Align(
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

  Widget listCase(List<CaseReport> caseList){
    return Stack(
      children: [
        ListView.builder(
          itemCount: caseList.length,
          itemBuilder: (context, index) {
            final CaseReport caseReport = caseList[index];
            if (reportedPostIds.contains(caseReport.id)) {
              return Container(); // Skip rendering this post
            }
            return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(caseReport.description!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text('Address: ${caseReport.address!}'),
                      SizedBox(height: 4), // Add some space between Address and Date
                      Text(
                        'Date: ${func.getFormattedDate(caseReport.dateTime!)}',
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      // Handle delete button press
                    },
                  ),
                  onTap: () {
                    _editReport(caseReport);
                  },
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
