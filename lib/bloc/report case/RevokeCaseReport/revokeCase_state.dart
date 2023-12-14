import 'package:equatable/equatable.dart';

class RevokeCaseState extends Equatable{
  @override
  List<Object> get props => [];
}

// Revoke Case Report
class RevokeCaseInitState extends RevokeCaseState {}

class RevokeCaseLoadingState extends RevokeCaseState {}

class RevokeCaseSuccessState extends RevokeCaseState {}

class RevokeCaseFailState extends RevokeCaseState {
  final String message;

  RevokeCaseFailState({required this.message});

}

