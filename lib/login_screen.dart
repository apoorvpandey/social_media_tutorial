import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate_to_next_screen/bloc/auth_bloc.dart';
import 'package:navigate_to_next_screen/bloc/auth_event.dart';
import 'package:navigate_to_next_screen/bloc/auth_state.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Welcome')),
        body: BlocConsumer<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) {
            if (state is GoogleSigningSuccess) {
              _navigateToHome();
            }
          },
          builder: (context, state) {
            return Center(
                child: state is GoogleSigningIn
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _signInWithGoogle,
                        child: const Text('Sign In With Google')));
          },
        ));
  }

  void _signInWithGoogle() => _authBloc.add(SignInWithGoogle());

  void _navigateToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
  }
}
