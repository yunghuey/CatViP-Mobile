import 'package:equatable/equatable.dart';

class EditPostState extends Equatable{
  @override
  List<Object> get props => [];
}

// Edit Posts
class EditPostInitState extends EditPostState {}

class EditPostLoadingState extends EditPostState {}

class EditPostSuccessState extends EditPostState {}

class EditPostFailState extends EditPostState {
  final String message;
  EditPostFailState({required this.message});
}


