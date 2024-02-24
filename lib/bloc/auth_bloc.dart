import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigate_to_next_screen/bloc/auth_event.dart';
import 'package:navigate_to_next_screen/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<SignInWithGoogle>((event, emit) => _signInWithGoogle(emit));
  }

  Future<void> _signInWithGoogle(Emitter<AuthState> emit) async {
    try {
      emit(GoogleSigningIn());
      GoogleSignInAccount? currentUser;
      final firebaseAuth = FirebaseAuth.instance;
      const List<String> scopes = ['email'];
      GoogleSignIn googleSignIn =
          GoogleSignIn(scopes: scopes, signInOption: SignInOption.standard);
      currentUser = await googleSignIn.signIn();
      if (currentUser == null) {
        emit(GoogleSigningFailed(error: 'Google Sign In Failed!'));
        return;
      }
      final authentication = await currentUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);
      final userCredentials =
          await firebaseAuth.signInWithCredential(credential);
      final profile = userCredentials.additionalUserInfo!.profile;
      emit(GoogleSigningSuccess());
      debugPrint(profile.toString());
    } catch (error) {
      emit(GoogleSigningFailed(error: 'Google Sign In Failed: $error'));
      debugPrint('_signInWithGoogleError: $error');
    }
  }
}
