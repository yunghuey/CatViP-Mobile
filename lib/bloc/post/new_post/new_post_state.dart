
import 'package:equatable/equatable.dart';

import '../../../model/cat/cat_model.dart';
import '../../../model/post/postType.dart';

class NewPostState extends Equatable{
  @override
  List<Object> get props => [];
}

// Get Posts
class NewPostInitState extends NewPostState {}

class NewPostLoadingState extends NewPostState {}

class NewPostFailState extends NewPostState {
  final String message;
  NewPostFailState({required this.message});
}

class NewPostSuccessState extends NewPostState {}

// // Get Post Types
// class GetPostTypeInitial extends NewPostState { }
//
// class GetPostTypeLoading extends NewPostState { }
//
// class GetPostTypeLoaded extends NewPostState {
//   final List<PostType> postTypes;
//   GetPostTypeLoaded({required this.postTypes});
// }
//
// class GetPostTypeError extends NewPostState {
//   final String? error;
//   GetPostTypeError({required this.error});
// }

