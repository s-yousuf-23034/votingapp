abstract class PhoneVerificationState {}

class PhoneVerificationInitial extends PhoneVerificationState {}

class PhoneVerificationLoading extends PhoneVerificationState {}

class PhoneVerificationSuccess extends PhoneVerificationState {
  final String phoneNumber;

  PhoneVerificationSuccess(this.phoneNumber);
}

class PhoneVerificationFailure extends PhoneVerificationState {
  final String error;

  PhoneVerificationFailure(this.error);
}