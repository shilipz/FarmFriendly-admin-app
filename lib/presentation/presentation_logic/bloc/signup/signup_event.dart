part of 'signup_bloc.dart';

class SignupEvent {
  final String email;

  final String username;
  final String password;

  SignupEvent(
      {required this.username, required this.email, required this.password});
}
