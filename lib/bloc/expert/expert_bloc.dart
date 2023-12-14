import 'package:CatViP/bloc/expert/expert_event.dart';
import 'package:CatViP/bloc/expert/expert_state.dart';
import 'package:CatViP/model/expert/expert_model.dart';
import 'package:CatViP/repository/expert_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertBloc extends Bloc<ExpertEvent,ExpertState> {
  ExpertRepository repo;

  ExpertBloc(ExpertState initialState, this.repo) : super(initialState){
    on<ApplyButtonPressed>((event, emit) async {
      emit(ExpertLoadingState());
      bool isApplied = await repo.createExpert(event.desc, event.document);
      if (isApplied){
        emit(AppliedSuccessState());
      } else {
        emit(AppliedFailState(message: "Error in applying expert"));
      }
    });

    on<LoadExpertApplicationEvent>((event, emit) async{
      emit(ExpertLoadingState());
      ExpertApplyModel? formList = await repo.getMyApplication();
      if (formList != null){
        emit(LoadedFormState(form: formList));
      } else {
        emit(EmptyFormState());
      }
    });

    on<RevokeButtonPressed>((event, emit) async{
      bool isRevoke = await repo.revokeApplication(event.formid);
      // connection to api
      if (isRevoke){
        emit(RevokeSuccessState());
      }
      else {
        emit(RevokeFailState());
      }
    });
  }
}