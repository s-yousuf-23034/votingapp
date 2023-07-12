import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/home/bloc/splash_bloc.dart';
import 'package:votingapp/profile.dart';
import 'package:votingapp/signup/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: MaterialApp(
        title: "IBA Alumni Voting App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.black,
          primaryColor: const Color.fromRGBO(97, 24, 33, 9),
        ),
        themeMode: ThemeMode.light,
        //home: OtpPage(),
        //home: SignUp(),
        //home: PhoneVerificationPage(phoneNumber: '',),
        //home: Login(),
        home: Profile(),
      ),
    );
  }
}
