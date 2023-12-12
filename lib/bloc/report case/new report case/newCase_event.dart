import 'package:equatable/equatable.dart';

class NewCaseEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartNewCase extends NewCaseEvents {}

class CaseReportButtonPressed extends NewCaseEvents{
  final String description;
  final String address;
  final double longitude;
  final double latitude;
  final List<String?> image;
  final int? catId;


  CaseReportButtonPressed({
    required this.description,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.image,
    required this.catId,
  });

}



