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
        emit(CatProfileLoadedState(cats: isFound));
      } else {
        emit(CatProfileEmptyState());
      }
    });

    on<UpdateCatPressed>((event, emit) async {
      emit(CatProfileLoadingState());
      int catid = event.cat.id;
      bool isUpdated = await repo.updateCat(event.cat);
      if (isUpdated){
        emit(CatUpdateSuccessState(catid: catid));
      } else {
        emit(CatUpdateErrorState(message: "Fail to update cat profile. Please try again later"));
      }
    });

    on<ReloadOneCatEvent>((event, emit) async {
      emit(CatProfileLoadingState());
      print("reloaded one cat event: ${event.catid}");
      CatModel? cat = await repo.getCat(event.catid);
      if (cat != null){
        print("bloc receive cat");
        emit(LoadedOneCatState(cat: cat));
      } else {
        emit(CatProfileEmptyState());
      }
    });

    on<DeleteCatPressed>((event, emit) async {
      emit(CatProfileLoadingState());
      bool isDeleted = await repo.removeCat(event.catid);
      if (isDeleted){
        print("cat deleted");
        emit(CatDeleteSuccessState(message: "Cat is removed succesfully"));
      }
      else {
        emit(CatDeleteErrorState(message: "Fail to remove cat"));
      }
    });

    on<SearchReloadAllCatEvent>((event, emit) async {
      emit(CatProfileLoadingState());
      List<CatModel>? isFound = await repo.getAllCatsByUserId(event.userID);
      if (isFound.length > 0){
        print("get cat by userid success");
        emit(CatProfileLoadedState(cats: isFound));
      } else {
        emit(CatProfileEmptyState());
      }
    });
  }
}