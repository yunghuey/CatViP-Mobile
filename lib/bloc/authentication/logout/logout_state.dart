import 'package:equatable/equatable.dart';

class LogoutState extends Equatable {
  @override
  List<Object> get props => [];
}
class LogoutInitState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessState extends LogoutState {}

class LogoutFailState extends LogoutState {}
