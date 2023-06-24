// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:votingapp/otp_page/bloc/opt_event.dart';
// import 'package:votingapp/otp_page/bloc/otp_state.dart';

// class OtpBloc extends Bloc<OtpEvent, OtpState> {
//   OtpBloc() : super(OtpInitial());

//   @override
//   Stream<OtpState> mapEventToState(OtpEvent event) async* {
//     if (event is SendOtp) {
//       yield* _mapSendOtpToState(event.phoneNumber);
//     } else if (event is ValidateOtp) {
//       yield* _mapValidateOtpToState(event.otpCode);
//     }
//   }

//   Stream<OtpState> _mapSendOtpToState(String phoneNumber) async* {
//     yield OtpSending();
//     // Simulate sending OTP code to the user's phone
//     await Future.delayed(Duration(seconds: 2));
//     yield OtpSent();
//   }

//   Stream<OtpState> _mapValidateOtpToState(String otpCode) async* {
//     yield OtpValidating();
//     // Simulate validating OTP code
//     await Future.delayed(Duration(seconds: 2));
//     if (otpCode == "1234") {
//       yield OtpValidated();
//     } else {
//       yield OtpInvalid();
//     }
//   }
// }
