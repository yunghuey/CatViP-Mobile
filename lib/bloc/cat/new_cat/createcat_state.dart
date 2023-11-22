import 'package:equatable/equatable.dart';

class CreateCatState extends Equatable{
  @override
  List<Object> get props => [];
}

class CreateCatInitState extends CreateCatState {}

class CreateCatLoadingState extends CreateCatState {}

class CreateCatFailState extends CreateCatState {
  final String message;
  CreateCatFailState({required this.message});
}

class CreateCatSuccessState extends CreateCatState {}