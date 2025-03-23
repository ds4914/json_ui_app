part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final String? verificationId;
  final  bool? isOtpSent;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isOtpSent,
    this.verificationId,
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    String? verificationId,
    bool? isOtpSent
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, errorMessage];
}
