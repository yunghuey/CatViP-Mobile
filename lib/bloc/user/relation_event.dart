import 'package:equatable/equatable.dart';

class RelationEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class FollowButtonPressed extends RelationEvent{
  int userID;
  FollowButtonPressed({ required this.userID });
}

class UnfollowButtonPressed extends RelationEvent{
  int userID;
  UnfollowButtonPressed({ required this.userID});
}