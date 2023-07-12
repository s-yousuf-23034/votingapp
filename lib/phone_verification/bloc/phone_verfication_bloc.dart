import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/phone_verification/bloc/phone_verfication_event.dart';
import 'package:votingapp/phone_verification/bloc/phone_verfication_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PhoneVerificationBloc() : super(PhoneVerificationInitial()) {
    on<SendCodeButtonPressed>(_onSendCodeButtonPressed);
  }

  Future<void> _onSendCodeButtonPressed(
    SendCodeButtonPressed event,
    Emitter<PhoneVerificationState> emit,
  ) async {
    emit(PhoneVerificationLoading());

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String phoneNumber = user.phoneNumber ?? '';
        emit(PhoneVerificationSuccess(phoneNumber));
      } else {
        emit(PhoneVerificationFailure('User not found'));
      }
    } catch (e) {
      emit(PhoneVerificationFailure(e.toString()));
    }
  }
}
