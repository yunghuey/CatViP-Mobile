
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/reportCase_repo.dart';
import 'newCase_event.dart';
import 'newCase_state.dart';

class NewCaseBloc extends Bloc<NewCaseEvents, NewCaseState>{

  ReportCaseRepository repostCaseRepo;
  CatRepository catRepo;

  NewCaseBloc(NewCaseState initialState, this.repostCaseRepo,this.catRepo):super(initialState){

    on<StartNewCase>((event, emit){
      emit(NewCaseInitState());
    });

    on<CaseReportButtonPressed>((event, emit) async{
      emit(NewCaseLoadingState());

      bool isCreated = await repostCaseRepo.newReportCase(
          event.description,
          event.address,
          event.longitude,
          event.latitude,
          event.image,
          event.catId
      );
      if (isCreated) {
        emit(NewCaseSuccessState());
      } else {
        emit(NewCaseFailState(message: "Fail to create case"));
      }
    });


  }
}
