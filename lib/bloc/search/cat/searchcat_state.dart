import 'package:CatViP/model/cat/cat_model.dart';
import 'package:equatable/equatable.dart';

class SearchCatProfileState extends Equatable{
  @override
  List<Object> get props => [];
}

class SearchCatInitState extends SearchCatProfileState {}

class SearchCatProfileLoadedState extends SearchCatProfileState {
  final List<CatModel> cats;
  SearchCatProfileLoadedState({required this.cats});
}

class SearchCatLoadingState extends SearchCatProfileState {}

class SearchCatProfileEmptyState extends SearchCatProfileState { }
