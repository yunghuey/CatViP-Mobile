import 'package:equatable/equatable.dart';

import '../../../model/post/post.dart';

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