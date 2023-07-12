import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/forgot_password/bloc/forgot_password_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: BlocProvider(
        create: (context) => ForgotPasswordBloc(),
        child: const ForgotPasswordForm(),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16.0),
          BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset link sent!')),
                );
              } else if (state is ForgotPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is ForgotPasswordLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  forgotPasswordBloc.add(ForgotPasswordButtonPressed());
                },
                child: const Text('Reset Password'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
