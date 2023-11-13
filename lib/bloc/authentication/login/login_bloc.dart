import 'package:CatViP/bloc/authentication/login/login_event.dart';
import 'package:CatViP/bloc/authentication/login/login_state.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      print('in bloc');
      bool getNewToken = await repo.refreshToken();
      if (getNewToken){
        emit(RefreshTokenSuccess());
      } else{
        emit(RefreshTokenFail());
      }
    });

    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoadingState());
      
      bool isValidLogin = await repo.login(event.username, event.password);
      // print(isValidLogin);
      if (isValidLogin)
      {
        emit(UserLoginSuccessState());
      }
      else
      {
        emit(LoginErrorState(message: "Invalid username or password"));
      }
    });


  }}

