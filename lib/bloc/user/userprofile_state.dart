import 'package:CatViP/model/user/user_model.dart';
import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable{
  @override
  List<Object> get props => [];
}
class UserProfileInitState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserModel user;
  UserProfileLoadedState({required this.user});
}

class SearchProfileLoadedState extends UserProfileState {
  final UserModel user;
  SearchProfileLoadedState({required this.user});
}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileErrorState extends UserProfileState {
  final message;
  UserProfileErrorState({required this.message});
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileUpdated extends UserProfileState {}

class SearchSuccessState extends UserProfileState {
  List<UserModel> searchList;
  SearchSuccessState({ required this.searchList });
}

class SearchFailState extends UserProfileState {
  String message;
  SearchFailState({ required this.message});
}

