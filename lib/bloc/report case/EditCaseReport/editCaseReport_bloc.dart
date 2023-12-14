import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/reportCase_repo.dart';
import 'editCaseReport_event.dart';
import 'editCaseReport_state.dart';

class CompleteCaseBloc extends Bloc<CompleteCaseEvents, CompleteCaseState>{

  ReportCaseRepository caseRepo;

  CompleteCaseBloc(CompleteCaseState initialState, this.caseRepo,):super(initialState){

    on<StartCompleteCase>((event, emit){
      emit(CompleteCaseInitState());
    });

    on<CompleteButtonPressed>((event, emit) async{
      emit(CompleteCaseLoadingState());

      bool isCreated = await caseRepo.completeCase(event.postId,);
      if (isCreated) {
        emit(CompleteCaseSuccessState());
      } else {
        emit(CompleteCaseFailState(message: "Fail to complete case"));
      }
    });


  }
}
