import 'package:bloc/bloc.dart';
import 'package:cucumber_admin/domain/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuthServices firebaseAuthServicesInstance =
      FirebaseAuthServices();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      firebaseAuthServicesInstance.signIn(event.email, event.password);
      emit(LoginState());
    });
  }
}
