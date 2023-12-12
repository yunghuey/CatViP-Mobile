import 'package:CatViP/bloc/user/userprofile_event.dart';
import 'package:CatViP/bloc/user/userprofile_state.dart';
import 'package:CatViP/model/expert/expert_model.dart';
import 'package:CatViP/model/user/user_model.dart';
import 'package:CatViP/repository/expert_repo.dart';
import 'package:CatViP/repository/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState>{
  UserRepository repo;
  ExpertRepository exprepo;
  UserProfileBloc(UserProfileState initialState, this.repo, this.exprepo):super(initialState){
    on<StartLoadProfile>((event, emit) async {
      emit(UserProfileLoadingState());
      UserModel? isFound = await repo.getUser();
      ExpertApplyModel? formList = await exprepo.getAllMyApplication();
      /*
      validToApply
      0 = never apply before
      1 = already an expert
      2 = rejected
      3 = pending
       */
      if (isFound != null){
        if (isFound.isExpert!){
          isFound.validToApply = 1;
        }
        else {
          if (formList != null){
            if (formList.status == "Rejected"){
              isFound.validToApply = 2;
            }
            else if (formList.status == "Pending"){
              isFound.validToApply = 3;
            } else if (formList.status == "Revoked"){
              isFound.validToApply = 0;
            }
          } else {
            isFound.validToApply = 0;
          }
        }
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
        emit(SearchProfileLoadedState(user: isFound));
      } else {
        emit(UserProfileErrorState(message: "Unable to load user profile"));
      }
    });


  }
}