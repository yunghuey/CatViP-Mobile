import 'package:equatable/equatable.dart';

class RelationState extends Equatable{
  @override
  List<Object> get props => [];
}
class RelationInitState extends RelationState {}
class UpdateFollowingState extends RelationState{}

class UpdateUnfollowingState extends RelationState{}

class RelationFailState extends RelationState{
  final String message;
  RelationFailState({ required this.message });
}