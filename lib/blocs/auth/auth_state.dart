part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User user;
  final AuthStatus status;

  AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

  factory AuthState.unkown() => AuthState();

  factory AuthState.authenticated({@required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user, status];
}
