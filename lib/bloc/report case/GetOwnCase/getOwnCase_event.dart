import 'package:equatable/equatable.dart';

class GetCaseEvent extends Equatable{
  const GetCaseEvent();
  @override
  List<Object> get props => [];
}

class GetCaseList extends GetCaseEvent {}

// Get Case Report Comments
class GetCaseReportComments extends GetCaseEvent {
  int caseReportId;
  GetCaseReportComments({required this.caseReportId});
}

// create new comment
class StartNewCaseReportComment extends GetCaseEvent {}

class PostCaseReportCommentPressed extends GetCaseEvent{
  final String description;
  final int caseReportId;

  PostCaseReportCommentPressed({
    required this.description,
    required this.caseReportId,
  });
}

class StartLoadOwnCase extends GetCaseEvent {}

// class StartLoadSingleCatPost extends GetPostEvent {
//   int catid;
//   StartLoadSingleCatPost({required this.catid});
// }

// // update action post
// class StartActionPost extends GetPostEvent {}
//
// class UpdateActionPost extends GetPostEvent {
//
//   final int postId;
//   final int actionTypeId;
//
//   UpdateActionPost({
//     required this.postId,
//     required this.actionTypeId,
//   });
// }
//
// // delete action post
// class StartDeleteActionPost extends GetPostEvent {}
//
// class DeleteActionPost extends GetPostEvent {
//
//   final int postId;
//
//   DeleteActionPost({
//     required this.postId,
//   });
// }
//
//
// class LoadSearchAllPost extends GetPostEvent{
//   final int userid;
//   LoadSearchAllPost({ required this.userid});
// }
