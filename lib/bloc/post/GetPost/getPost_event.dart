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
