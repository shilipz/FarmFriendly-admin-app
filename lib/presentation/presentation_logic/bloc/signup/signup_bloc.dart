import 'package:bloc/bloc.dart';
import 'package:cucumber_admin/domain/auth.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuthServices firebaseAuthServicesInstance =
      FirebaseAuthServices();
  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>((event, emit) {
      firebaseAuthServicesInstance.signUp(
          event.email, event.password, event.username);

      emit(SignupState());
    });
  }
}
