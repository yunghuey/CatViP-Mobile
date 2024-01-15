import 'package:CatViP/bloc/report%20case/ReportCaseCount/CaseReportCountEvent.dart';
import 'package:CatViP/bloc/report%20case/ReportCaseCount/CaseReportCountState.dart';
import 'package:CatViP/repository/reportCase_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseReportCountBloc extends Bloc<CaseReportCountEvent, CaseReportCountState>{
  ReportCaseRepository repo;
  CaseReportCountBloc(CaseReportCountState initialState, this.repo):super(initialState){
    on<CaseCountInitEvent>((event, emit) async {
      emit(CaseReportResetState());
      int num = await repo.getNearByCaseCount();
      if(num == 0){
        emit(EmptyCaseState());
      } else {
      emit(CaseExistState(num: num));
      }
    });
  }
}
