import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/login/Login.dart';
import 'package:votingapp/signup/bloc/SignUpBloc.dart';
import 'package:votingapp/signup/bloc/SignUpState.dart';
import 'package:votingapp/widgets/textformfield.dart';
//import 'package:phone_number/phone_number.dart';

class SignUp extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  RegExp regExp = RegExp(SignUp.pattern as String);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController(text: '+92');
  final cnicController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminStatusOptions = ['Non-Admin', 'Admin'];
  String selectedAdminStatus = 'Non-Admin'; // Default admin status

  String? validation() {
    String? phoneNumber;
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Name cannot be Empty',
        ),
      ));
    } else if (nameController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check Your Name'),
        ),
      );
    }
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone number cannot be empty.'),
      ));
    } else {
      String phoneNumber = phoneController.text.trim();
      phoneNumber = phoneNumber.replaceAll(
          ' ', ''); // Remove any spaces from the phone number
      phoneNumber = phoneNumber.replaceAll(
          '-', ''); // Remove any dashes from the phone number

      if (!_isPhoneNumberValid(phoneNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a valid phone number.'),
        ));
      }
    }

    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Email cannot be Empty',
        ),
      ));
    } else if (!regExp.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter the valid Email',
        ),
      ));
    }
    if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Password cannot be Empty',
        ),
      ));
    } else if (passwordController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password length must be at least 8.'),
        ),
      );
    } else if (!_isPasswordValid(passwordController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password must contain at least 8 characters, 1 special character, 1 numeric digit, and 1 uppercase letters.'),
        ),
      );
    } else if (SignUpState is SignUpFailure) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign Up Error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      phoneNumber = '+92$phoneNumber';
      registerUser();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Registered Successfully',
        ),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }
  }

  bool _isPasswordValid(String password) {
    // Password must contain at least 8 characters, 1 special character, 1 numeric digit, and 1 uppercase letters.
    RegExp passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z]{1,})(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    RegExp phoneRegExp = RegExp(r'^\+92[0-9]{10}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  void _onPhoneChanged(String value) {
    // Ensure the value always starts with "+92"
    if (!value.startsWith('+92')) {
      setState(() {
        phoneController.text = '+92$value';
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneController.text.length),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpBloc(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Register',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(97, 24, 33, 9),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                MyTextField(
                                  icon: const Icon(Icons.person),
                                  value: false,
                                  hinttext: 'Your Name',
                                  labeltext: 'Full Name',
                                  color: Color.fromRGBO(97, 24, 33, 9),
                                  type: TextInputType.text,
                                  action: TextInputAction.next,
                                  controller: nameController,
                                ),
                                MyTextField(
                                  icon: const Icon(Icons.phone),
                                  value: false,
                                  hinttext: 'Phone Number',
                                  labeltext: 'Phone Number',
                                  color: Color.fromRGBO(97, 24, 33, 9),
                                  type: TextInputType.phone,
                                  action: TextInputAction.next,
                                  controller: phoneController,
                                ),
                                MyTextField(
                                  icon: const Icon(Icons.credit_card),
                                  value: false,
                                  hinttext: 'CNIC Number',
                                  labeltext: 'CNIC Number',
                                  color: Color.fromRGBO(97, 24, 33, 9),
                                  type: TextInputType.number,
                                  action: TextInputAction.next,
                                  controller: cnicController,
                                ),
                                MyTextField(
                                  icon: const Icon(Icons.email),
                                  value: false,
                                  hinttext: 'abc@gmail.com',
                                  labeltext: 'Email',
                                  color: Color.fromRGBO(97, 24, 33, 9),
                                  type: TextInputType.emailAddress,
                                  action: TextInputAction.next,
                                  controller: emailController,
                                ),
                                MyTextField(
                                  icon: const Icon(Icons.lock),
                                  value: true,
                                  hinttext: 'Enter Password',
                                  labeltext: 'Password',
                                  color: Color.fromRGBO(97, 24, 33, 9),
                                  type: TextInputType.text,
                                  action: TextInputAction.done,
                                  controller: passwordController,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('By signing up you agree to our',
                                        style: TextStyle(
                                          color: Color.fromRGBO(97, 24, 33, 9),
                                        )),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => Login(),
                                        //   ),
                                        // );
                                      },
                                      child: Text(
                                        'Terms & Conditions and Privacy Policy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(97, 24, 33, 9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    validation();
                                  },
                                  child: Text('Continue'),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    minimumSize: Size(350, 50),
                                    backgroundColor:
                                        Color.fromRGBO(97, 24, 33, 9),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                // Text(
                                //   " OR CONNECT WITH ",
                                //   style: TextStyle(
                                //     color: Color.fromARGB(255, 60, 5, 69),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Divider(
                                //     thickness: 1.0,
                                //     color: Color.fromARGB(255, 60, 5, 69),
                                //   ),
                                // ),

                                // ElevatedButton.icon(
                                //   onPressed: () {
                                //     // Handle Google sign-in
                                //   },
                                //   icon: Icon(Icons.g_mobiledata),
                                //   label: Text('Sign in with Google'),
                                //   style: ElevatedButton.styleFrom(
                                //     primary: Colors.red,
                                //     onPrimary: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(25.0),
                                //     ),
                                //   ),
                                // ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Already signed up?',
                                        style: TextStyle(
                                          color: Color.fromRGBO(97, 24, 33, 9),
                                        )),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(97, 24, 33, 9),
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
                  ],
                ),
              ),
            )));
  }

  Future<void> registerUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'full name': nameController.text,
          'phone number': phoneController.text,
          'cnic': cnicController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'adminStatus': selectedAdminStatus,
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CourseList(
        //       username: nameController.text,
        //       isAdmin: selectedAdminStatus == 'Admin',
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      print(e);
    }
  }
}
