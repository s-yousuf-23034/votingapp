import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/home/bloc/splash_bloc.dart';
import 'package:votingapp/home/home.dart';
import 'package:votingapp/otp_page/otp_page.dart';
import 'package:votingapp/signup/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: MaterialApp(
        title: "IBA Alumni Voting App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.black,
          primaryColor: Color.fromRGBO(97, 24, 33, 9),
        ),
        themeMode: ThemeMode.light,
        //home: OtpPage(),
        home: SignUp(),
      ),
    );
  }
}
