import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_event.dart';
import 'package:CatViP/bloc/authentication/forgot_password/forgotpwd_state.dart';
import 'package:CatViP/repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPwdBloc extends Bloc<ForgotPwdEvent, ForgotPwdState>{
  AuthRepository repo;

  ForgotPwdBloc(ForgotPwdState initialState, this.repo): super(initialState){
    on<StartEvent>((event, emit){
      emit(PasswordInitState());
    });

    on<SendButtonPressed>((event, emit) async{
      emit(SendingLoadingState());
      bool validEmail = await repo.sendEmail(event.email);
      if (validEmail){
        emit(SentEmailSuccess());
      } else {
        emit(SentEmailFail());
      }
    });
  }

}