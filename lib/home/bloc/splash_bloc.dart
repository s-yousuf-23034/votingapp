import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/home/bloc/splash_event.dart';
import 'package:votingapp/home/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashScreenInitial()) {
    on<AppStarted>((event, emit) {
      emit(SplashScreenNavigateToLogin());
    });

    Timer(Duration(seconds: 3), () {
      add(AppStarted());
    });
  }
}
