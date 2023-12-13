import 'package:equatable/equatable.dart';

class LogoutEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class LogoutResetEvent extends LogoutEvents { }
class LogoutButtonPressed extends LogoutEvents {
}