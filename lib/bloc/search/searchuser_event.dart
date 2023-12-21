import 'package:equatable/equatable.dart';

class SearchUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitEvent extends SearchUserEvent {}

class SearchUserPressed extends SearchUserEvent {
  String name;
  SearchUserPressed({ required this.name });
}