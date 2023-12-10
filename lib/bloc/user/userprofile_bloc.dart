import 'package:CatViP/bloc/user/userprofile_event.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState>{
  UserRepository repo;
  UserProfileBloc(UserProfileState initialState, this.repo):super(initialState){
    on<StartLoadProfile>((event, emit) async {
      emit(UserProfileLoadingState());
      print("in bloc loading user");
      UserModel? isFound = await repo.getUser();
      if (isFound != null){
        print("get user info successfully");

        emit(UserProfileLoadedState(user: isFound));
      } else{
        UserProfileErrorState(message: "Fail to load user profile");
      }
    });

    on<UpdateButtonPressed>((event, emit) async {
        emit(UserProfileUpdating());
        bool isUpdated = await repo.updateUser(event.user);
        if (isUpdated){
          emit(UserProfileUpdated());
        } else{
          emit(UserProfileErrorState(message: "Error in updating"));
        }
    });

    on<SearchUserPressed>((event, emit) async{
      emit(UserProfileLoadingState());
      List<UserModel>? isFound = await repo.getSearchResult(event.name);
      if (isFound.length > 0){
        emit(SearchSuccessState(searchList: isFound));
      } else {
        emit(SearchFailState(message: "No user is found"));
      }
    });

    on<LoadSearchUserEvent>((event, emit) async {
      emit(UserProfileLoadingState());
      UserModel? isFound = await repo.getSearchUserInfo(event.userid);
      if (isFound != null){
        emit(UserProfileLoadedState(user: isFound));
      } else {
        emit(UserProfileErrorState(message: "Unable to load user profile"));
      }
    });


  }
}