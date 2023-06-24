import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashScreenInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashScreenNavigateToLogin extends SplashState {
  @override
  List<Object> get props => [];
}
