import 'package:CatViP/bloc/authentication/login/login_event.dart';
import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class AuthBloc extends Bloc<AuthEvents, AuthState>{
  // declare repo attribute
  AuthRepository repo;
  // constructor
  AuthBloc(AuthState initialState, this.repo): super(initialState) {

    on<StartEvent>((event, emit) {
      emit(LoginInitState());
    });

    on<EmptyField>((event,emit) {
      emit(LoginErrorState(message: "Please fill up the form"));
    });

    on<GetRefreshToken>((event, emit) async{
      bool getNewToken = await repo.refreshToken();
      if (getNewToken){
        emit(RefreshTokenSuccess());
      } else{
        emit(RefreshTokenFail());
      }
    });

    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoadingState());
      
      int isValidLogin = await repo.login(event.username, event.password);
      print(isValidLogin);
      if (isValidLogin == 1)
      {
        OneSignal.login(event.username);
        emit(UserLoginSuccessState());
      }
      else if (isValidLogin == 0)
      {
        emit(LoginErrorState(message: "Invalid username or password"));
      } else if (isValidLogin == 2){
        emit(LoginErrorState(message: "Unable to connect with server. Please try again later."));
      }
    });

    on<GetLogin>((event, emit) {
      emit(LoginInitState());
    });

  }}

