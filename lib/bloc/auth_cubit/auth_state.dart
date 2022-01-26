part of "auth_cubit.dart";

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedUp extends AuthState {}

class AuthSignedIn extends AuthState {}

class AuthSignOut extends AuthState {}

class AuthError extends AuthState {
  final String errMessage;

  AuthError(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
