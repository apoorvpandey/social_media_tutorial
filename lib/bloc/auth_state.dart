abstract class AuthState {}

class AuthInitialState extends AuthState {}

class GoogleSigningIn extends AuthState {}

class GoogleSigningSuccess extends AuthState {}

class GoogleSigningFailed extends AuthState {
  final String error;

  GoogleSigningFailed({required this.error});
}
