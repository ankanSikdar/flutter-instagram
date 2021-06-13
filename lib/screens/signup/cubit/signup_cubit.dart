import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignUpStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignUpStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignUpStatus.initial));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignUpStatus.submitting) return;
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authRepository.signUpWithEmailAndPassword(
          username: state.username,
          email: state.email,
          password: state.password);
      // If no error
      emit(state.copyWith(status: SignUpStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignUpStatus.error));
    }
  }
}
