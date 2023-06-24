abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpButtonPressed(
      {required this.name, required this.email, required this.password});
}
