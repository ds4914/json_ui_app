import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsonuiapp/services/auth_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthState.initial()) {
    on<HandleAuth>(_handleAuth);
    on<AuthLogout>(_handleLogout);
    on<AuthStateChanged>(_handleAuthStateChanged);

    _initializeAuthState();
  }

  void _initializeAuthState() {
    final User? currentUser = _firebaseAuth.currentUser;
    add(AuthStateChanged(currentUser)); // Ensure initial state is correct

    _firebaseAuth.authStateChanges().listen((User? user) {
      add(AuthStateChanged(user));
    });
  }
  Future<void> _handleAuth(HandleAuth event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      User? user;
      switch (event.authType) {
        case "google_auth":
          user = await _authService.signInWithGoogle();
          break;
        case "apple_auth":
          user = await _authService.signInWithApple();
          break;
        case "firebase_email_password":
          user = await _authService.signInWithEmailPassword(
            event.email!,
            event.password!,
          );
          break;
        case "firebase_signup":
          user = await _authService.signUpWithEmailPassword(
            event.email!,
            event.password!,
          );
          break;
        case "phone_auth":
          await _authService.signInWithPhone(
            event.phoneNumber!,
                (verificationId, resendToken) {
              emit(state.copyWith(
                isOtpSent: true,
                verificationId: verificationId,
                isLoading: false,
              ));
            },
          );
          return;
      }

      if (user != null) {
        emit(state.copyWith(user: user, isLoading: false, isOtpSent: false));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Login failed"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _handleAuthStateChanged(
      AuthStateChanged event,
      Emitter<AuthState> emit,
      ) {
    if (event.user != null) {
      emit(state.copyWith(user: event.user, isLoading: false));
    } else {
      emit(AuthState.initial());
    }
  }

  Future<void> _handleLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(AuthState.initial());
  }
}
