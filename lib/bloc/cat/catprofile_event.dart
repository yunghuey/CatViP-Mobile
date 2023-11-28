import 'package:CatViP/model/cat/cat_model.dart';
import 'package:equatable/equatable.dart';

class CatProfileEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartLoadCat extends CatProfileEvent {}

class UpdateCatPressed  extends CatProfileEvent {
  final CatModel cat;
  UpdateCatPressed({required this.cat});
}

class DeleteCatPressed extends CatProfileEvent {
  final int catid;
  DeleteCatPressed({ required this.catid});
}

class ReloadOneCatEvent extends CatProfileEvent {
  final int catid;
  ReloadOneCatEvent({required this.catid});
}