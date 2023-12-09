import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/post_repo.dart';
import 'deletePost_event.dart';
import 'deletePost_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvents, DeletePostState>{

  PostRepository postRepo;

  DeletePostBloc(DeletePostState initialState, this.postRepo,):super(initialState){

    on<StartDeletePost>((event, emit){
      emit(DeletePostInitState());
    });

    on<DeleteButtonPressed>((event, emit) async{
      emit(DeletePostLoadingState());

      bool isCreated = await postRepo.deletePost(event.postId);
      if (isCreated) {
        emit(DeletePostSuccessState());
      } else {
        emit(DeletePostFailState(message: "Fail to delete post"));
      }
    });

  }
}
