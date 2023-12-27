import 'package:CatViP/bloc/report%20case/ReportCaseCount/CaseReportCountBloc.dart';
import 'package:CatViP/bloc/report%20case/ReportCaseCount/CaseReportCountState.dart';
import 'package:CatViP/pages/report/MapCaseReports.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


class MissingCaseIcon extends StatefulWidget {
  const MissingCaseIcon({super.key});

  @override
  State<MissingCaseIcon> createState() => _MissingCaseIconState();
}

class _MissingCaseIconState extends State<MissingCaseIcon> {
  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<CaseReportCountBloc,CaseReportCountState>(
          builder: (context, state){
            if (state is CaseExistState){
              return Badge.Badge(
                badgeContent: Text(state.num.toString(), style: TextStyle(color: Colors.white)),
                badgeStyle: Badge.BadgeStyle(
                  shape: Badge.BadgeShape.circle,
                  badgeColor: HexColor("#3c1e08"),
                  padding: const EdgeInsets.all(8.0),
                ),
                child:  FloatingActionButton(
                  heroTag: "casereporttag",
                  backgroundColor
                      : Colors.brown,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapCaseReports()));
                  },
                  child: Icon(Icons.warning_amber),
                ),
              );
            }
            else {
              return FloatingActionButton(
                heroTag: "casereporttag",
                backgroundColor
                    : Colors.brown,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapCaseReports()));
                },
                child: Icon(Icons.warning_amber),
              );
          }
          })
    ;
  }
}
