import 'package:equatable/equatable.dart';

import '../../../model/post/post.dart';
import '../../../model/post/postComment.dart';

class GetPostState extends Equatable{
  const GetPostState();
  @override
  List<Object> get props => [];
}

class GetPostInitial extends GetPostState { }

class GetPostLoading extends GetPostState { }

class GetPostLoaded extends GetPostState {
  final List<Post> postList;
  const GetPostLoaded({required this.postList});
}

class GetPostError extends GetPostState {
  final String? error;
  const GetPostError({required this.error});
}

class GetPostEmpty extends GetPostState {}

class GetPostSingleCatLoaded extends GetPostState{
  final List<Post> postList;
  const GetPostSingleCatLoaded({required this.postList});
}

// Get Post Comments
class GetPostCommentInitial extends GetPostState { }

class GetPostCommentLoading extends GetPostState { }

class GetPostCommentLoaded extends GetPostState {
  final List<PostComment> postComments;
  const GetPostCommentLoaded({required this.postComments});

}

class GetPostCommentError extends GetPostState {
  final String? error;
  GetPostCommentError({required this.error});
}

// Create comment
class NewCommentInitState extends GetPostState {}

class NewCommentLoadingState extends GetPostState {}

class NewCommentFailState extends GetPostState {
  final String message;
  NewCommentFailState({required this.message});
}

class NewCommentIsNull extends GetPostState {
  final String message;
  NewCommentIsNull({required this.message});
}

class NewCommentSuccessState extends GetPostState {}

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