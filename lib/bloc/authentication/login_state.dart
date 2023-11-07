import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  // getter method that return a list
  List<Object> get props => [];
}

// when the page is first load
class LoginInitState extends AuthState {}

//when the form is submitted and it is waiting
class LoginLoadingState extends AuthState {}

class UserLoginSuccessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String message;
  LoginErrorState({required this.message});

}

class RefreshTokenSuccess extends AuthState{}

class RefreshTokenFail extends AuthState{}