import 'package:equatable/equatable.dart';

class DeletePostState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Posts
class DeletePostInitState extends DeletePostState {}

class DeletePostLoadingState extends DeletePostState {}

class DeletePostSuccessState extends DeletePostState {}

class DeletePostFailState extends DeletePostState {
  final String message;
  DeletePostFailState({required this.message});
}


