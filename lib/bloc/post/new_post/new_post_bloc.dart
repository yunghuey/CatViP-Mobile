import 'package:CatViP/model/cat/cat_model.dart';
import 'package:CatViP/model/post/postType.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/postType_repo.dart';
import '../../../repository/post_repo.dart';
import 'new_post_event.dart';
import 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvents, NewPostState> {
  PostRepository postRepo;
  PostTypeRepository postTypeRepo;
  CatRepository catRepo;

  NewPostBloc(
      NewPostState initialState, this.postRepo, this.postTypeRepo, this.catRepo): super(initialState) {
    on<StartNewPost>((event, emit) {
      emit(NewPostInitState());
    });

    on<PostButtonPressed>((event, emit) async {
      emit(NewPostLoadingState());

      bool isCreated = await postRepo.newPost(event.description, event.postTypeId, event.image, event.catIds);
      if (isCreated) {
        emit(NewPostSuccessState());
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var message = prefs.getString('message')!;
        emit(NewPostFailState(message: message));
      }
    });
  }
}
