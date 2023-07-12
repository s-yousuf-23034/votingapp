import 'dart:async';
import 'package:bloc/bloc.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordButtonPressed) {
      yield ForgotPasswordLoading();
      try {
        // Add your forgot password logic here
        await Future.delayed(
            const Duration(seconds: 2)); // Simulating an async operation
        yield ForgotPasswordSuccess();
      } catch (error) {
        yield ForgotPasswordFailure(error.toString());
      }
    }
  }
}
