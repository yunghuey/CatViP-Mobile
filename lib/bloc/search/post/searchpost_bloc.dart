import 'package:CatViP/bloc/search/post/searchpost_event.dart';
import 'package:CatViP/bloc/search/post/searchpost_state.dart';
import 'package:CatViP/model/post/post.dart';
import 'package:CatViP/repository/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPostBloc extends Bloc<SearchGetPostEvent, SearchGetPostState> {
  PostRepository repo;

  SearchPostBloc(SearchGetPostState initialState, this.repo)
      :super(initialState) {
    on<LoadSearchAllPostEvent>((event, emit) async {
      emit(SearchPostLoadingState());
      final List<Post> postList = await repo.getAllPostsByUserId(event.userid);
      if (postList.length > 0) {
        emit(SearchGetPostSuccessState(posts: postList));
      } else {
        emit(SearchPostEmptyState());
      }
    });
  }
}