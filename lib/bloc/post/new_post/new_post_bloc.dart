
import 'package:CatViP/model/post/postType.dart';
import 'package:CatViP/repository/cat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../../repository/postType_repo.dart';
import '../../../repository/post_repo.dart';
import 'new_post_event.dart';
import 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvents, NewPostState>{

  PostRepository postRepo;
  PostTypeRepository postTypeRepo;

    NewPostBloc(NewPostState initialState, this.postRepo, this.postTypeRepo):super(initialState){

    on<StartNewPost>((event, emit){
      emit(NewPostInitState());
    });

    on<PostButtonPressed>((event, emit) async{
      emit(NewPostLoadingState());

      bool isCreated = await postRepo.newPost(event.description, event.postTypeId, event.image, event.catId);
      if (isCreated) {
        emit(NewPostSuccessState());
      } else {
        emit(NewPostFailState(message: "Fail to create post"));
      }
    });

    on<GetPostTypes>((event, emit) async {
      try {
        emit(GetPostTypeLoading());
        final List<PostType> postTypes = await postTypeRepo.fetchPostTypes();
        emit(GetPostTypeLoaded(postTypes: postTypes));

        if (postTypes[0].error != null) {
          emit(GetPostTypeError(
              error: postTypes[0].error));
        }
      }catch (e){
        emit(GetPostTypeError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
