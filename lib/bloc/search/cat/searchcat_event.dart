import 'package:equatable/equatable.dart';

class SearchCatProfileEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class SearchReloadAllCatEvent extends SearchCatProfileEvent{
  final int userID;
  SearchReloadAllCatEvent({ required this.userID});
}
