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
  final String address;
  final double latitude;
  final double longitude;

  SignUpButtonPressed({
    required this.username,
    required this.fullname,
    required this.email,
    required this.password,
    required this.gender,
    required this.bdayDate,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

