import 'package:CatViP/bloc/search/cat/searchcat_event.dart';
import 'package:CatViP/bloc/search/cat/searchcat_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCatBloc extends Bloc<SearchCatProfileEvent, SearchCatProfileState> {
  CatRepository repo;
  SearchCatBloc(SearchCatProfileState initialState, this.repo):super(initialState) {
    on<SearchReloadAllCatEvent>((event, emit) async {
      emit(SearchCatLoadingState());
      List<CatModel>? isFound = await repo.getAllCatsByUserId(event.userID);
      if (isFound.length > 0){
        emit(SearchCatProfileLoadedState(cats: isFound));
      } else {
        emit(SearchCatProfileEmptyState());
      }
    });
  }

}