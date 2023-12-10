import 'package:equatable/equatable.dart';

class GetPostEvent extends Equatable{
  const GetPostEvent();
  @override
  List<Object> get props => [];
}

class GetPostList extends GetPostEvent {}

class StartLoadOwnPost extends GetPostEvent {}

class StartLoadSingleCatPost extends GetPostEvent {
  int catid;
  StartLoadSingleCatPost({required this.catid});
}

class GetPostComments extends GetPostEvent {
  int postId;
  GetPostComments({required this.postId});
}

// create new comment
class StartNewComment extends GetPostEvent {}

// update action post
class StartActionPost extends GetPostEvent {}

class UpdateActionPost extends GetPostEvent {

  final int postId;
  final int actionTypeId;

  UpdateActionPost({
    required this.postId,
    required this.actionTypeId,
  });
}

class PostCommentPressed extends GetPostEvent{
  final String description;
  final int postId;

  PostCommentPressed({
    required this.description,
    required this.postId,
  });

}

class LoadSearchAllPost extends GetPostEvent{
  final int userid;
  LoadSearchAllPost({ required this.userid});
}