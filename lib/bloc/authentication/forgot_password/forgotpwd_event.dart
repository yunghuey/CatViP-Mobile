import 'package:equatable/equatable.dart';

class ForgotPwdEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartEvent extends ForgotPwdEvent {}

class SendButtonPressed extends ForgotPwdEvent {
  final String email;
  // constructor
  SendButtonPressed({required this.email});
}