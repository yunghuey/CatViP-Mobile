import 'package:equatable/equatable.dart';

class SearchUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitEvent extends SearchUserEvent {}

class SearchUserPressed extends SearchUserEvent {
  final String name;
  SearchUserPressed({ required this.name });
}

class SearchUserProfileEvent extends SearchUserEvent {
  final int userid;
  SearchUserProfileEvent({ required this.userid });
}