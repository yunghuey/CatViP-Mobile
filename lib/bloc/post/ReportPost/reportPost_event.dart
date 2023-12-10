import 'package:equatable/equatable.dart';


class ReportPostEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartReportPost extends ReportPostEvents {}

class ReportButtonPressed extends ReportPostEvents{
  final int postId;
  final String description;

  ReportButtonPressed({
    required this.postId,
    required this.description,
  });

}