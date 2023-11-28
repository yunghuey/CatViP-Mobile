
import 'package:CatViP/repository/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../model/post/post.dart';
import 'getPost_event.dart';
import 'getPost_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {

  final PostRepository postRepository = PostRepository();

  GetPostBloc() : super(GetPostInitial()) {
    on<GetPostList>((event, emit) async {
      try {
        emit(GetPostLoading());
        final List<Post> postList = await postRepository.fetchPost();
        emit(GetPostLoaded(postList: postList));

        if (postList[0].error != null) {
          emit(GetPostError(
              error: postList[0].error));
        }
      } on http.ClientException {
        emit(const GetPostError(
            error: "Failed to fetch data in your device online"));
      }
    });

    on<StartLoadOwnPost>((event, emit) async{
      emit(GetPostLoading());
      final List<Post> postList = await postRepository.fetchPost();
      if (postList.length > 0){
        emit(GetPostLoaded(postList: postList));
      } else{
        emit(GetPostEmpty());
      }
    });
    
    on<StartLoadSingleCatPost>((event, emit) async {
      emit(GetPostLoading());
      final List<Post> postList = await postRepository.fetchCatPost(event.catid);
      if (postList.length > 0){
        emit(GetPostSingleCatLoaded(postList: postList));
      } else{
        emit(GetPostEmpty());
      }
    });
  }

}