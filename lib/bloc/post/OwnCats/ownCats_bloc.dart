
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/cat/cat_model.dart';
import 'ownCats_event.dart';
import 'ownCats_state.dart';


class OwnCatsBloc extends Bloc<OwnCatsEvents, OwnCatsState>{
  CatRepository catRepo;

  OwnCatsBloc(GetOwnCatsInitial initialState,this.catRepo):super(initialState){

    // Get Own Cats
    on<GetOwnCats>((event, emit) async {
      try {
        emit(GetOwnCatsLoading());
        final List<CatModel> cats = await catRepo.getAllCats();
        emit(GetOwnCatsLoaded(cats: cats));

      }catch (e){
        emit(GetOwnCatsError(
            error: "Failed to fetch data in your device online"));
      }
    });

  }
}