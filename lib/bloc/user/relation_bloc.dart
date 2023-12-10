import 'package:CatViP/bloc/user/relation_event.dart';
import 'package:CatViP/bloc/user/relation_state.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelationBloc extends Bloc<RelationEvent, RelationState>{
  UserRepository repo;
  RelationBloc(RelationState initialState, this.repo):super(initialState){
    on<FollowButtonPressed>((event, emit) async {
      int isCompleted = await repo.followUser(event.userID);

      if (isCompleted == 0){
        emit(RelationFailState(message: "Unable to follow this user"));
      }
      else if (isCompleted == 3){
        emit(RelationFailState(message: "Internal Error to follow"));
      }
      else if (isCompleted == 1){
        emit(UpdateFollowingState());
      }
    });

    on<UnfollowButtonPressed>((event, emit) async {
      int isCompleted = await repo.unfollowUser(event.userID);
      if (isCompleted == 0){
        emit(RelationFailState(message: "Unable to unfollow this user"));
      }
      else if (isCompleted == 3){
        emit(RelationFailState(message: "Internal Error to unfollow"));
      }
      else if (isCompleted == 1){
        emit(UpdateUnfollowingState());
      }
    });
  }
}