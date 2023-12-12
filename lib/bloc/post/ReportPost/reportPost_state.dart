import 'package:equatable/equatable.dart';

class ReportPostState extends Equatable{
  @override
  List<Object> get props => [];
}

// Report Posts
class ReportPostInitState extends ReportPostState {}

class ReportPostLoadingState extends ReportPostState {}

class ReportPostSuccessState extends ReportPostState {}

class ReportPostFailState extends ReportPostState {
  final String message;
  ReportPostFailState({required this.message});
}


