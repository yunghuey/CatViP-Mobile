import 'package:CatViP/bloc/authentication/login_event.dart';
import 'package:CatViP/bloc/authentication/login_state.dart';
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

    on<LoginButtonPressed>((event, emit) async {
      var pref = await SharedPreferences.getInstance();
      emit(LoginLoadingState());
      
      var isValidLogin = await repo.login(event.username, event.password);

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


    //

  // @override
  // // async* for Stream
  // Stream<AuthState> mapEventToState(AuthEvents event)  async*{
  //   print("inside LOgin_bloc");
  //     var pref = await SharedPreferences.getInstance();
  //     if (event is StartEvent){
  //       yield LoginInitState();
  //     } else if (event is LoginButtonPressed){
  //       yield LoginLoadingState();
  //       var data = await repo.login(event.username,event.password);
  //       // // pref.setString(data);
  //       print(data.toString());
  //       yield UserLoginSuccessState();
  //     } else {
  //       yield LoginErrorState(message: 'Invalid username or password.');
  //     }
  // }

