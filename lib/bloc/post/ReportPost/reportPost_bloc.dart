import 'package:CatViP/bloc/post/ReportPost/reportPost_event.dart';
import 'package:CatViP/bloc/post/ReportPost/reportPost_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/post_repo.dart';

class ReportPostBloc extends Bloc<ReportPostEvents, ReportPostState>{

  PostRepository postRepo;

  ReportPostBloc(ReportPostState initialState, this.postRepo,):super(initialState){

    on<StartReportPost>((event, emit){
      emit(ReportPostInitState());
    });

    on<ReportButtonPressed>((event, emit) async{

      emit(ReportPostLoadingState());

      try {
        bool isCreated = await postRepo.reportPost(event.postId, event.description);
        if (isCreated) {
          emit(ReportPostSuccessState());
        } else {
          emit(ReportPostFailState(message: "Failed to report post"));
        }
      } catch (e) {
        // Handle any potential errors during the process
        emit(ReportPostFailState(message: "Failed to report post"));
      }
    });

  }
}
