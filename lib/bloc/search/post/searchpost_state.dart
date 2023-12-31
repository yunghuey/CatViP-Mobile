import 'package:CatViP/model/post/post.dart';
import 'package:equatable/equatable.dart';

class SearchGetPostState extends Equatable{
  @override
  List<Object> get props => [];
}

class SearchPostInitState extends SearchGetPostState {}

class SearchGetPostSuccessState extends SearchGetPostState {
  final List<Post> posts;
  SearchGetPostSuccessState({ required this.posts });
}

class SearchPostLoadingState extends SearchGetPostState{ }

class SearchPostEmptyState extends SearchGetPostState {}