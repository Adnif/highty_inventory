import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:highty_inventory/domain/usecases/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({this.isLoading = false, this.errorMessage});
}

class LoginCubit extends Cubit<LoginState> {
  final SignInUseCase signInUseCase;

  LoginCubit(this.signInUseCase) : super(LoginState());

  Future<void> signIn(BuildContext context, email, String password) async {
    emit(LoginState(isLoading: true));
    try {
      final user = await signInUseCase.call(email, password);
      if (user != null) {
        // Navigate to home screen or handle successful login
        log('${user.fullName}');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', user.fullName!);
        Navigator.popAndPushNamed(context, '/homescreen');
      } else {
        emit(LoginState(errorMessage: "Login failed. Please try again."));
      }
    } catch (e) {
      emit(LoginState(errorMessage: e.toString()));
    } finally {
      emit(LoginState(isLoading: false));
    }
  }
}
