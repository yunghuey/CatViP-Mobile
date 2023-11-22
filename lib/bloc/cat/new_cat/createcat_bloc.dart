
import 'package:CatViP/bloc/cat/new_cat/createcat_event.dart';
import 'package:CatViP/bloc/cat/new_cat/createcat_state.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCatBloc extends Bloc<CreateCatEvents, CreateCatState>{
  CatRepository repo;
  CreateCatBloc(CreateCatState initialState, this.repo):super(initialState){
    on<StartCreateCat>((event, emit){
      emit(CreateCatInitState());
    });

    on<CreateButtonPressed>((event, emit) async{
      emit(CreateCatLoadingState());

      bool isCreated = await repo.createCat(event.catname, event.catdesc, event.dob, event.gender, event.imagebyte);
      if (isCreated) {
        emit(CreateCatSuccessState());
      } else {
        emit(CreateCatFailState(message: "Fail to create cat"));
      }
    });
  }
}
