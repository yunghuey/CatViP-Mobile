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

class PostCommentPressed extends GetPostEvent{
  final String description;
  final int postId;

  PostCommentPressed({
    required this.description,
    required this.postId,
  });

}