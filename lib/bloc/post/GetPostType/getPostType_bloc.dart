import 'package:CatViP/model/post/postType.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/postType_repo.dart';
import 'getPostType_event.dart';
import 'getPostType_state.dart';

class GetPostTypeBloc extends Bloc<GetPostTypeEvents, GetPostTypeState>{

  PostTypeRepository postTypeRepo;

  GetPostTypeBloc(GetPostTypeState initialState,this.postTypeRepo):super(initialState){

    // Get Post Types
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
