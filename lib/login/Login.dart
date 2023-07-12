import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:votingapp/auth_services/firebase_auth.dart';
import 'package:votingapp/login/bloc/LoginBloc.dart';
import 'package:votingapp/phone_verification/phone_verification.dart';
import 'package:votingapp/signup/signup.dart';
import 'package:votingapp/widgets/textformfield.dart';

class Login extends StatefulWidget {
  final String phoneNumber;

  const Login({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool? isAdmin;
  bool rememberMe = false;

  late LoginBloc _loginBloc;

  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

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
      String? userName = userData['name'] as String?;
      return userName ?? ''; // Return an empty string if userName is null
    } else {
      return ''; // Return an empty string if the document does not exist
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
              const SizedBox(height: 30),
              const Text(
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
                      icon: const Icon(Icons.email),
                      value: false,
                      hinttext: 'abc@gmail.com',
                      labeltext: 'Email',
                      prefixText: '',
                      color: const Color.fromRGBO(97, 24, 33, 9),
                      type: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      controller: emailController,
                      suffixIcon: null,
                    ),
                    const SizedBox(height: 20.0),
                    MyTextField(
                      icon: const Icon(Icons.lock),
                      value: !isPasswordVisible,
                      hinttext: 'Enter Password',
                      labeltext: 'Password',
                      prefixText: '',
                      color: const Color.fromRGBO(97, 24, 33, 9),
                      type: TextInputType.text,
                      action: TextInputAction.done,
                      controller: passwordController,
                      suffixIcon: GestureDetector(
                        onTap: togglePasswordVisibility,
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
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
                            const Text(
                              'Remember Me',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(97, 24, 33, 9),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
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
                            String phoneNumber = '';

                            // Fetch user's phone number from Firebase
                            DocumentSnapshot userSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.uid)
                                    .get();
                            if (userSnapshot.exists) {
                              phoneNumber =
                                  userSnapshot['phone number'] as String;
                            }

                            isAdmin = await _loginBloc.isAdmin(
                              emailController.text.toString(),
                              passwordController.text.toString(),
                            );

                            bool isAdminValue = isAdmin ?? false;

                            if (isAdminValue) {
                              print('Admin');
                              // navigateToAdminSettingsPage(userName);
                            } else {
                              // Navigate to PhoneVerification with phone number
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhoneVerification(
                                    phoneNumber: phoneNumber,
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        minimumSize: const Size(350, 50),
                        backgroundColor: const Color.fromRGBO(97, 24, 33, 9),
                      ),
                      child: const Text("Login"),
                    ),
                    const SizedBox(height: 10.0),
                    const Row(
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
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color.fromRGBO(97, 24, 33, 9),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: const Text(
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
