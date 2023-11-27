import 'package:equatable/equatable.dart';

class CreateCatEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartCreateCat extends CreateCatEvents {}

class CreateButtonPressed extends CreateCatEvents{
  final String catname;
  final String catdesc;
  final String dob;
  final int gender;
  final String imagebyte;

  CreateButtonPressed({
    required this.catname,
    required this.catdesc,
    required this.dob,
    required this.gender,
    required this.imagebyte,
  });
}
