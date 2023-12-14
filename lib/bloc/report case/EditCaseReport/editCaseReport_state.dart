import 'package:equatable/equatable.dart';

class CompleteCaseState extends Equatable{
  @override
  List<Object> get props => [];
}

// Complete Case Report
class CompleteCaseInitState extends CompleteCaseState {}

class CompleteCaseLoadingState extends CompleteCaseState {}

class CompleteCaseSuccessState extends CompleteCaseState {}

class CompleteCaseFailState extends CompleteCaseState {
  final String message;
  CompleteCaseFailState({required this.message});
}



