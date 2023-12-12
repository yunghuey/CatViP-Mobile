
import 'package:equatable/equatable.dart';


class NewCaseState extends Equatable{
  @override
  List<Object> get props => [];
}

// New Case Report
class NewCaseInitState extends NewCaseState {}

class NewCaseLoadingState extends NewCaseState {}

class NewCaseFailState extends NewCaseState {
  final String message;
  NewCaseFailState({required this.message});
}

class NewCaseSuccessState extends NewCaseState {}


