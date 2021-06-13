part of 'signup_cubit.dart';

enum SignUpStatus { initial, submitting, success, error }

class SignUpState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignUpStatus status;
  final Failure failure;

  bool get isFormValid =>
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  const SignUpState({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.status,
    @required this.failure,
  });

  factory SignUpState.initial() {
    return SignUpState(
      username: '',
      email: '',
      password: '',
      status: SignUpStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [username, email, password, status, failure];

  SignUpState copyWith({
    String username,
    String email,
    String password,
    SignUpStatus status,
    Failure failure,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
