import 'package:equatable/equatable.dart';

class ForgotPwdState extends Equatable{
  @override
  List<Object> get props => [];
}

class PasswordInitState extends ForgotPwdState { }

class SendingLoadingState extends ForgotPwdState { }

class SentEmailSuccess extends ForgotPwdState { }

class SentEmailFail extends ForgotPwdState { }