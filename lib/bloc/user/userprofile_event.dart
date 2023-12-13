import 'package:CatViP/model/user/user_model.dart';
import 'package:equatable/equatable.dart';

class UserProfileEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartLoadProfile extends UserProfileEvent {}

class UpdateButtonPressed extends UserProfileEvent {
  UserModel user;
  UpdateButtonPressed({ required this.user });
}

class ResetSearchEvent extends UserProfileEvent {}

class SearchUserPressed extends UserProfileEvent {
  String name;
  SearchUserPressed({ required this.name });
}

class LoadSearchUserEvent extends UserProfileEvent {
  int userid;
  LoadSearchUserEvent({ required this.userid});
}