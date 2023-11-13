import 'package:equatable/equatable.dart';

class RegisterState extends Equatable{
  @override
  List<Object> get props => [];
}

class RegisterInitState extends RegisterState {}

class RegisterLoadingState extends RegisterState{}

class RegisterSuccessState extends RegisterState{}

class RegisterFailState extends RegisterState{
  final String message;
  RegisterFailState({required this.message});
}

class UsernameFailState extends RegisterState{ }

class EmailFailState extends RegisterState{ }