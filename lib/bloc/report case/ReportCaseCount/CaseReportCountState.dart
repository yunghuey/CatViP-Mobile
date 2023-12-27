import 'package:equatable/equatable.dart';

class CaseReportCountState extends Equatable{
  @override
  List<Object> get props => [];
}

class CaseReportInitState extends CaseReportCountState {}

class EmptyCaseState extends CaseReportCountState{ }

class CaseExistState extends CaseReportCountState{
  final int num;
  CaseExistState({ required this.num});
}