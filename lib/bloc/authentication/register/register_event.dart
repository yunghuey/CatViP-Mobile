import 'package:equatable/equatable.dart';


class RegisterEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends RegisterEvents {}

class SignUpButtonPressed extends RegisterEvents {
  final String username;
  final String fullname;
  final String email;
  final String password;
  final int gender;
  final String bdayDate;

  SignUpButtonPressed({
    required this.username,
    required this.fullname,
    required this.email,
    required this.password,
    required this.gender,
    required this.bdayDate
  });
}

