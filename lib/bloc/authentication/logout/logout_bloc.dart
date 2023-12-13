import 'package:CatViP/bloc/authentication/logout/logout_event.dart';
import 'package:CatViP/bloc/authentication/logout/logout_state.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutBloc extends Bloc<LogoutEvents, LogoutState>{
  AuthRepository repo;
  LogoutBloc(LogoutState initialState, this.repo): super(initialState){
    on<LogoutButtonPressed>((event, emit) async{
      bool isLogout = await repo.logout();
      if(isLogout){
        emit(LogoutSuccessState());
      } else {
        emit(LogoutFailState());
      }
    });

    on<LogoutResetEvent>((event, emit) async {
      emit(LogoutInitState());
    });
  }
}