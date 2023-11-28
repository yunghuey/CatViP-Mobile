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

class CatUpdateSuccessState extends CatProfileState {
  final int catid;
  CatUpdateSuccessState({ required this.catid});
}

class CatUpdateErrorState extends CatProfileState {
  final String message;
  CatUpdateErrorState({required this.message});
}

class CatDeleteSuccessState extends CatProfileState {
  final String message;
  CatDeleteSuccessState({required this.message});
}

class CatDeleteErrorState extends CatProfileState{
  final String message;
  CatDeleteErrorState({required this.message});
}

class LoadedOneCatState extends CatProfileState{
  CatModel cat;
  LoadedOneCatState({required this.cat});
}