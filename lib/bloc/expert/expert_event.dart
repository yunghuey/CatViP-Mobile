import 'package:equatable/equatable.dart';

class ExpertEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadExpertApplicationEvent extends ExpertEvent {}

class ApplyButtonPressed extends ExpertEvent{
  String desc;
  String document;
  ApplyButtonPressed({ required this.desc, required this.document });
}

class RevokeButtonPressed extends ExpertEvent {
  int formid;
  RevokeButtonPressed({ required this.formid});
}