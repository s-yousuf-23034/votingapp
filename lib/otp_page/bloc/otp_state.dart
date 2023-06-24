import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpSending extends OtpState {}

class OtpSent extends OtpState {}

class OtpValidating extends OtpState {}

class OtpValidated extends OtpState {}

class OtpInvalid extends OtpState {}
