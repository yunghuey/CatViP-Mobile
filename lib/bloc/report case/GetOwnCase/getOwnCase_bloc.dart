import 'package:CatViP/model/caseReport/caseReport.dart';
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
        emit(GetCaseLoading());
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

    /* on<StartLoadSingleCatPost>((event, emit) async {
      emit(GetPostLoading());
      final List<Post> postList = await postRepository.fetchCatPost(
          event.catid);
      if (postList.length > 0) {
        emit(GetPostSingleCatLoaded(postList: postList));
      } else {
        emit(GetPostEmpty());
      }
    });

    on<GetPostComments>((event, emit) async {
      try {
        emit(GetPostCommentLoading());
        print(event.postId);
        final List<PostComment> postComments = await postRepository
            .fetchPostComments(event.postId);
        emit(GetPostCommentLoaded(postComments: postComments));

        if (postComments[0].error != null) {
          emit(GetPostCommentError(
              error: postComments[0].error));
        }
      } catch (e) {
        emit(GetPostCommentError(
            error: "Be the first to comment!"));
      }
    });

    // create new comment
    on<StartNewComment>((event, emit) {
      emit(NewCommentInitState());
    });

    on<PostCommentPressed>((event, emit) async {
      emit(NewCommentLoadingState());
      try {
        // Attempt to post a new comment
        bool isCreated = await postRepository.newComment(
            event.description, event.postId);

        if (isCreated) {
          // If the comment is successfully created, fetch the updated comments
          final List<PostComment> updatedCommentList = await postRepository
              .fetchPostComments(event.postId);
          print(event.postId);
          // Update the state with the new list of comments
          emit(NewCommentSuccessState());
          emit(GetPostCommentLoaded(postComments: updatedCommentList));
        } else if (event.description == "") {
          final List<PostComment> updatedCommentList = await postRepository
              .fetchPostComments(event.postId);
          print(event.postId);
          print("test ${event.description}");
          // Update the state with the new list of comments
          emit(NewCommentSuccessState());
          emit(GetPostCommentLoaded(postComments: updatedCommentList));
        } else {
          emit(NewCommentFailState(message: "Failed to create comment"));
        }
      } catch (e) {
        // Handle any potential errors during the process
        emit(NewCommentFailState(message: "Failed to create comment"));
      }
    });

    // update action post
    on<StartActionPost>((event, emit) {
      emit(ActionPostInitState());
    });

    on<UpdateActionPost>((event, emit) async {

      try {
        // Attempt to post a new comment
        bool isUpdated = await postRepository.actionPost(
            event.postId, event.actionTypeId);

        print(event.postId);
        print(event.actionTypeId);
        print(isUpdated);
        if (isUpdated) {
          // Update the state with the new list of comments
          emit(ActionPostSuccessState());
        }
      } catch (e) {
        // Handle any potential errors during the process
        emit(ActionPostFailState(message: "Failed to update action"));
      }
    });

    // update action post
    on<StartDeleteActionPost>((event, emit) {
      emit(DeleteActionPostInitState());
    });

    on<DeleteActionPost>((event, emit) async {

      try {

        bool isUpdated = await postRepository.deleteActPost(event.postId);

      } catch (e) {
        // Handle any potential errors during the process
        emit(ActionPostFailState(message: "Failed to update action"));
      }
    });

    on<LoadSearchAllPost>((event, emit) async {
      emit(GetPostLoading());
      print("loadsearchallpost ${event.userid}");
      final List<Post> postList = await postRepository.getAllPostsByUserId(event.userid);
      if (postList.length > 0) {
        emit(GetPostLoaded(postList: postList));
      } else {
        emit(GetPostEmpty());
      }
    });
  }
*/
  }
}
