import 'package:CatViP/bloc/cat/catprofile_event.dart';
import 'package:CatViP/bloc/cat/catprofile_state.dart';
import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatProfileBloc extends Bloc<CatProfileEvent, CatProfileState>{
  CatRepository repo;
  CatProfileBloc(CatProfileState initialState, this.repo):super(initialState){
    on<StartLoadCat>((event, emit) async{
      emit(CatProfileLoadingState());
      List<CatModel>? isFound = await repo.getAllCats();
      if (isFound.length > 0){
        print("get all cats successfully");
        emit(CatProfileLoadedState(cats: isFound));
      } else {
        emit(CatProfileEmptyState());
      }
    });
  }
}