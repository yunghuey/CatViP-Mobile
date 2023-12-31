import 'package:CatViP/model/user/user_model.dart';
import 'package:equatable/equatable.dart';

class SearchUserState extends Equatable{
  @override
  List<Object> get props => [];
}
// for seaching UI
class SearchUserInitState extends SearchUserState{}

class SearchUserLoadingState extends SearchUserState {}

class SearchUserEmptyState extends SearchUserState {}

class SearchUserLoadedState extends SearchUserState {
  List<UserModel> searchList;
  SearchUserLoadedState({ required this.searchList});
}
// displaying UI
class SearchUserProfileLoaded extends SearchUserState {
 final UserModel user;
 SearchUserProfileLoaded({ required this.user });
}

class SearchUserProfileError extends SearchUserState{
  final String message;
  SearchUserProfileError({ required this.message });
}