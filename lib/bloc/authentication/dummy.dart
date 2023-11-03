// import 'package:CatViP/bloc/authentication/form_submission_status.dart';
// import 'package:CatViP/bloc/authentication/login_bloc.dart';
// import 'package:CatViP/bloc/authentication/login_event.dart';
// import 'package:CatViP/bloc/authentication/login_state.dart';
// import 'package:CatViP/repository/auth_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class LoginView extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (context) => LoginBloc(
//           authRepo: context.read<AuthRepository>(),
//         ),
//       ),
//     );
//   }
//
//   Widget _loginForm(){
//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context,state){
//         final formStatus = state.formStatus;
//         if (formStatus is SubmissionFailed){
//           _showSnackBar(context, formStatus.exception.toString());
//         }
//       },
//       child: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _usernameField(),
//               _passwordField(),
//               _loginButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _usernameField(){
//     return BlocBuilder<LoginBloc, LoginState>(builder: (context,state){
//       return TextFormField(
//         decoration: const InputDecoration(
//           icon: Icon(Icons.person),
//           hintText: 'Username',
//         ),
//         validator: (value) => state.isValidUsername ? null : 'Username is too short',
//         onChanged: (value) =>
//             context.read<LoginBloc>().add(LoginUsernameChanged(username: value)),
//       );
//     },);
//   }
//
//   Widget _passwordField(){
//     return BlocBuilder<LoginBloc, LoginState>(builder: (context,state) {
//       return TextFormField(
//         obscureText: true,
//         decoration: const InputDecoration(
//           icon: Icon(Icons.lock),
//           hintText: 'Password',
//         ),
//         validator: (value) => state.isValidPassword ? null : 'Password is too short',
//         onChanged: (value) => context.read<LoginBloc>().add(
//           LoginPasswordChanged(password: value),
//         ),
//       );
//     });
//   }
//
//   Widget _loginButton(){
//     return BlocBuilder<LoginBloc, LoginState>(builder: (context,state){
//       return state.formStatus is FormSubmitting ?
//       CircularProgressIndicator() :
//       ElevatedButton(onPressed: (){
//         if (_formKey.currentState!.validate()){
//           context.read<LoginBloc>().add(LoginSubmitted());
//         }
//       }, child: const Text('Sign In')
//       );
//     });
//   }
//
//   void _showSnackBar(BuildContext context, String message){
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
