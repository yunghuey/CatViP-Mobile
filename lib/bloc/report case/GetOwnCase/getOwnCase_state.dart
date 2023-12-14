import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:equatable/equatable.dart';

import '../../../model/caseReport/caseReportComments.dart';
import '../../../model/post/post.dart';
import '../../../model/post/postComment.dart';

class GetCaseState extends Equatable{
  const GetCaseState();
  @override
  List<Object> get props => [];
}

class GetCaseInitial extends GetCaseState { }

class GetCaseLoading extends GetCaseState { }

class GetCaseLoaded extends GetCaseState {
  final List<CaseReport> caseList;
  const GetCaseLoaded({required this.caseList});
}

class GetCaseError extends GetCaseState {
  final String? error;
  const GetCaseError({required this.error});
}

class GetCaseEmpty extends GetCaseState {}



// Get Post Comments
class GetCaseReportCommentInitial extends GetCaseState { }

class GetCaseReportCommentLoading extends GetCaseState { }

class GetCaseReportCommentLoaded extends GetCaseState {
  final List<CaseReportComment> caseReportComments;
  const GetCaseReportCommentLoaded({required this.caseReportComments});

}

class GetCaseReportCommentError extends GetCaseState {
  final String? error;
  GetCaseReportCommentError({required this.error});
}

// Create comment
class NewCaseReportCommentInitState extends GetCaseState {}

class NewCaseReportCommentLoadingState extends GetCaseState {}

class NewCaseReportCommentFailState extends GetCaseState {
  final String message;
  NewCaseReportCommentFailState({required this.message});
}

class NewCaseReportCommentIsNull extends GetCaseState {
  final String message;
  NewCaseReportCommentIsNull({required this.message});
}

class NewCaseReportCommentSuccessState extends GetCaseState {}

/*
// update action post
class ActionPostInitState extends GetPostState {}

class ActionPostLoadingState extends GetPostState {}

class ActionPostFailState extends GetPostState {
  final String message;
  ActionPostFailState({required this.message});
}

class ActionPostSuccessState extends GetPostState {}

// delete action post
class DeleteActionPostInitState extends GetPostState {}

class DeleteActionPostLoadingState extends GetPostState {}

class DeleteActionPostFailState extends GetPostState {
  final String message;
  DeleteActionPostFailState({required this.message});
}

class DeleteActionPostSuccessState extends GetPostState {}
*/
