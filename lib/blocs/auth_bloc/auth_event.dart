part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HandleAuth extends AuthEvent {
  final String authType;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? otp;

  HandleAuth({required this.authType, this.otp,this.email, this.password, this.phoneNumber});

  @override
  List<Object?> get props => [authType, email, password, phoneNumber,otp];
}

class AuthLogout extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final User? user;

  AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}
