import 'package:CatViP/bloc/report%20case/RevokeCaseReport/revokeCase_event.dart';
import 'package:CatViP/bloc/report%20case/RevokeCaseReport/revokeCase_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/reportCase_repo.dart';

class RevokeCaseBloc extends Bloc<RevokeCaseEvents, RevokeCaseState>{

  ReportCaseRepository caseRepo;

  RevokeCaseBloc(RevokeCaseState initialState, this.caseRepo,):super(initialState){

    on<StartRevokeCase>((event, emit){
      emit(RevokeCaseInitState());
    });

    on<RevokeCaseButtonPressed>((event, emit) async{
      emit(RevokeCaseLoadingState());

      bool isCreated = await caseRepo.revokeCase(event.postId,);
      if (isCreated) {
        emit(RevokeCaseSuccessState());
      } else {
        emit(RevokeCaseFailState(message: "Fail to revoke case"));
      }
    });

  }
}
