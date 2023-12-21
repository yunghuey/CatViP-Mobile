import 'package:CatViP/bloc/search/searchuser_event.dart';
import 'package:CatViP/bloc/search/searchuser_state.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState>{
  UserRepository repo;

  SearchUserBloc(SearchUserState initialState, this.repo):super(initialState){
    on<SearchInitEvent>((event, emit){
      emit(SearchUserInitState());
    });

    on<SearchUserPressed>((event, emit) async{
      emit(SearchUserLoadingState());
      List<UserModel>? isFound = await repo.getSearchResult(event.name);
      if (isFound.length > 0){
        emit(SearchUserLoadedState(searchList: isFound));
      }
      else {
        emit(SearchUserEmptyState());
      }
    });
  }
}