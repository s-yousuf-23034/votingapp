import 'package:equatable/equatable.dart';

class OtpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendOtp extends OtpEvent {
  final String phoneNumber;

  SendOtp(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class ValidateOtp extends OtpEvent {
  final String otpCode;

  ValidateOtp(this.otpCode);

  @override
  List<Object> get props => [otpCode];
}
