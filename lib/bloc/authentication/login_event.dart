import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable{
  @override
  // getter method that return a list
  List<Object> get props => [];
}

class StartEvent extends AuthEvents {}

class LoginButtonPressed extends AuthEvents{
  // define the DTO needed
  final String username;
  final String password;

  // constructor
  LoginButtonPressed({required this.username, required this.password});
}

class EmptyField extends AuthEvents{}