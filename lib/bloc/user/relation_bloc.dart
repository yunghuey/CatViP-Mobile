import 'package:CatViP/bloc/user/relation_event.dart';
import 'package:CatViP/bloc/user/relation_state.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelationBloc extends Bloc<RelationEvent, RelationState>{
  UserRepository repo;
  RelationBloc(RelationState initialState, this.repo):super(initialState){
    on<FollowButtonPressed>((event, emit){

    });
  }
}