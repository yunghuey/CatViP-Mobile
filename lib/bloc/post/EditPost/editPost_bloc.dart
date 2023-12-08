import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/post_repo.dart';
import 'editPost_event.dart';
import 'editPost_state.dart';

class EditPostBloc extends Bloc<EditPostEvents, EditPostState>{

  PostRepository postRepo;

  EditPostBloc(EditPostState initialState, this.postRepo,):super(initialState){

    on<StartEditPost>((event, emit){
      emit(EditPostInitState());
    });

    on<SaveButtonPressed>((event, emit) async{
      emit(EditPostLoadingState());

      bool isCreated = await postRepo.editPost(event.description, event.postId,);
      if (isCreated) {
        emit(EditPostSuccessState());
      } else {
        emit(EditPostFailState(message: "Fail to edit post"));
      }
    });

  }
}
