import 'package:equatable/equatable.dart';

class SearchGetPostEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class LoadSearchInitEvent extends SearchGetPostEvent { }

class LoadSearchAllPostEvent extends SearchGetPostEvent{
  final int userid;
  LoadSearchAllPostEvent({ required this.userid});
}