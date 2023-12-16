import 'package:equatable/equatable.dart';
import '../../../model/post/postType.dart';

class GetPostTypeState extends Equatable{
  @override
  List<Object> get props => [];
}

// Get Post Types
class GetPostTypeInitial extends GetPostTypeState { }

class GetPostTypeLoading extends GetPostTypeState { }

class GetPostTypeLoaded extends GetPostTypeState {
  final List<PostType> postTypes;
  GetPostTypeLoaded({required this.postTypes});
}

class GetPostTypeError extends GetPostTypeState {
  final String? error;
  GetPostTypeError({required this.error});
}

