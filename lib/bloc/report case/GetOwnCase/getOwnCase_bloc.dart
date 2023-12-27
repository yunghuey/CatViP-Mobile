import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:CatViP/model/caseReport/caseReportComments.dart';
import 'package:CatViP/repository/reportCase_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'getOwnCase_event.dart';
import 'getOwnCase_state.dart';

class GetCaseBloc extends Bloc<GetCaseEvent, GetCaseState> {

  final ReportCaseRepository reportCaseRepo = ReportCaseRepository();

  GetCaseBloc() : super(GetCaseInitial()) {
    on<GetCaseList>((event, emit) async {
      try {
        //emit(GetCaseLoading());
        final List<CaseReport> caseList = await reportCaseRepo.fetchCases();
        emit(GetCaseLoaded(caseList: caseList));

        if (caseList[0].error != null) {
          emit(GetCaseError(
              error: caseList[0].error));
        }
      } on http.ClientException {
        emit(const GetCaseError(
            error: "Failed to fetch data in your device online"));
      }
    });

    on<StartLoadOwnCase>((event, emit) async {
      emit(GetCaseLoading());
      final List<CaseReport> caseList = await reportCaseRepo.fetchMyCase();
      if (caseList.length > 0) {
        emit(GetCaseLoaded(caseList: caseList));
      } else {
        emit(GetCaseEmpty());
      }
    });

    on<GetCaseReportComments>((event, emit) async {
      try {
        emit(GetCaseReportCommentLoading());
        print(event.caseReportId);
        final List<CaseReportComment> caseReportComments =
            await reportCaseRepo.fetchCaseReportComments(event.caseReportId);
        emit(GetCaseReportCommentLoaded(caseReportComments: caseReportComments));

        if (caseReportComments[0].error != null) {
          emit(GetCaseReportCommentError(
              error: caseReportComments[0].error));
        }
      } catch (e) {
        emit(GetCaseReportCommentError(
            error: "Be the first to comment!"));
      }
    });

    // create new comment
    on<StartNewCaseReportComment>((event, emit) {
      emit(NewCaseReportCommentInitState());
    });

    on<PostCaseReportCommentPressed>((event, emit) async {
      emit(NewCaseReportCommentLoadingState());
      try {
        // Attempt to post a new comment
        bool isCreated = await reportCaseRepo.newCaseReportComment(
            event.description, event.caseReportId);

        if (isCreated) {
          // If the comment is successfully created, fetch the updated comments
          final List<CaseReportComment> updatedCaseReportCommentList = await reportCaseRepo
              .fetchCaseReportComments(event.caseReportId);
          print(event.caseReportId);
          // Update the state with the new list of comments
          emit(NewCaseReportCommentSuccessState());
          emit(GetCaseReportCommentLoaded(caseReportComments: updatedCaseReportCommentList));
        } else if (event.description == "") {
          final List<CaseReportComment> updatedCommentList = await reportCaseRepo
              .fetchCaseReportComments(event.caseReportId);
          print(event.caseReportId);
          print("test ${event.description}");
          // Update the state with the new list of comments
          emit(NewCaseReportCommentSuccessState());
          emit(GetCaseReportCommentLoaded(caseReportComments: updatedCommentList));
        } else {
          emit(NewCaseReportCommentFailState(message: "Failed to create comment"));
        }
      } catch (e) {
        // Handle any potential errors during the process
        emit(NewCaseReportCommentFailState(message: "Failed to create comment"));
      }
    });
    //
    // // load single cat post
    // on<StartLoadSingleCatPost>((event, emit) async {
    //   emit(GetPostLoading());
    //   final List<Post> postList = await postRepository.fetchCatPost(
    //       event.catid);
    //   if (postList.length > 0) {
    //     emit(GetPostSingleCatLoaded(postList: postList));
    //   } else {
    //     emit(GetPostEmpty());
    //   }
    // });
    //
    // // update action post
    // on<StartActionPost>((event, emit) {
    //   emit(ActionPostInitState());
    // });
    //
    // on<UpdateActionPost>((event, emit) async {
    //
    //   try {
    //     // Attempt to post a new comment
    //     bool isUpdated = await postRepository.actionPost(
    //         event.postId, event.actionTypeId);
    //
    //     print(event.postId);
    //     print(event.actionTypeId);
    //     print(isUpdated);
    //     if (isUpdated) {
    //       // Update the state with the new list of comments
    //       emit(ActionPostSuccessState());
    //     }
    //   } catch (e) {
    //     // Handle any potential errors during the process
    //     emit(ActionPostFailState(message: "Failed to update action"));
    //   }
    // });
    //
    // // update action post
    // on<StartDeleteActionPost>((event, emit) {
    //   emit(DeleteActionPostInitState());
    // });
    //
    // on<DeleteActionPost>((event, emit) async {
    //
    //   try {
    //
    //     bool isUpdated = await postRepository.deleteActPost(event.postId);
    //
    //   } catch (e) {
    //     // Handle any potential errors during the process
    //     emit(ActionPostFailState(message: "Failed to update action"));
    //   }
    // });
    //
    // on<LoadSearchAllPost>((event, emit) async {
    //   emit(GetPostLoading());
    //   print("loadsearchallpost ${event.userid}");
    //   final List<Post> postList = await postRepository.getAllPostsByUserId(event.userid);
    //   if (postList.length > 0) {
    //     emit(GetPostLoaded(postList: postList));
    //   } else {
    //     emit(GetPostEmpty());
    //   }
    // });
  }
}

