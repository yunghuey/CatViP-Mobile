import 'package:CatViP/model/cat/cat_model.dart';
import 'package:equatable/equatable.dart';

class CatProfileState extends Equatable{
  @override
  List<Object> get props => [];
}

class CatProfileInitState extends CatProfileState {}

class CatProfileLoadingState extends CatProfileState {}

class CatProfileLoadedState extends CatProfileState {
  final List<CatModel> cats;
  CatProfileLoadedState({required this.cats});
}

class CatProfileEmptyState extends CatProfileState { }