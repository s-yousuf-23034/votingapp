import 'package:email_validator/email_validator.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:votingapp/auth_services/firebase_auth.dart';
import 'package:votingapp/login/bloc/LoginBloc.dart';
import 'package:votingapp/otp_page/otp_page.dart';
import 'package:votingapp/signup/ui.dart';
import 'package:votingapp/widgets/textformfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool? isAdmin;
  bool rememberMe = false;

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<String> fetchUserName(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String userName = userData['name'];
      return userName;
    } else {
      return '';
    }
  }

  // void navigateToAdminSettingsPage(String userName) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AdminSettingsPage(
  //         userName: userName,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30),
              Text(
                "Login",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(97, 24, 33, 9),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    MyTextField(
                      icon: Icon(Icons.email),
                      hinttext: " abc@gmail.com",
                      labeltext: "Email",
                      color: Color.fromRGBO(97, 24, 33, 9),
                      type: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      controller: emailController,
                      value: false,
                    ),
                    const SizedBox(height: 20.0),
                    MyTextField(
                      icon: Icon(Icons.lock),
                      hinttext: "Password",
                      labeltext: "Password",
                      color: Color.fromRGBO(97, 24, 33, 9),
                      type: TextInputType.text,
                      action: TextInputAction.next,
                      controller: passwordController,
                      value: true,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(97, 24, 33, 9),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential =
                              await _auth.signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          );

                          if (userCredential.user != null) {
                            String userName =
                                await fetchUserName(userCredential.user!.uid);

                            isAdmin = await _loginBloc.isAdmin(
                              emailController.text.toString(),
                              passwordController.text.toString(),
                            );

                            bool isAdminValue = isAdmin ?? false;

                            if (isAdminValue) {
                              // navigateToAdminSettingsPage(userName);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpPage(
                                      // username: userName,
                                      // isAdmin: isAdminValue,
                                      ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        minimumSize: Size(350, 50),
                        backgroundColor: Color.fromRGBO(97, 24, 33, 9),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                        Text(
                          " or continue with ",
                          style: TextStyle(
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // print('Google');
                            FirebaseAuthMethods(FirebaseAuth.instance)
                                .signInWithGoogle(context);
                          },
                          child: Container(
                              width: 70,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/google.svg',
                                      height: 20,
                                      width: 20,
                                      color: Colors.white,
                                    ),
                                  ])),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromRGBO(97, 24, 33, 9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
