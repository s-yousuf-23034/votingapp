import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:votingapp/login/Login.dart';
import 'package:votingapp/signup/bloc/SignUpBloc.dart';
import 'package:votingapp/widgets/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  // static Pattern pattern =
  //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //RegExp regExp = RegExp(SignUp.pattern as String);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminStatusOptions = ['Non-Admin', 'Admin'];
  String selectedAdminStatus = 'Non-Admin'; // Default admin status
  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  // Error messages
  String nameError = '';
  String emailError = '';
  String passwordError = '';
  String phoneError = '';
  String cnicError = '';

  // Validators
  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name cannot be empty.";
    } else if (value.length < 3) {
      return "Name must be at least 3 characters.";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email cannot be empty.";
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty.";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters.";
    } else if (!value.contains(RegExp(
        r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()?]).{8,}'))) {
      return "Password must include at least one uppercase letter, one lowercase letter, one numeral, and one special character.";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.isEmpty) {
      return "Phone number cannot be empty.";
    } else if (!RegExp(r'^\+92-\d{3}-\d{7}$').hasMatch(value)) {
      return "Please enter a valid phone number (e.g., +92-XXX-XXXXXXX).";
    }
    return null;
  }

  String? validateCNIC(String value) {
    if (value.isEmpty) {
      return "CNIC number cannot be empty.";
    } else if (value.length != 15 ||
        !value.startsWith(RegExp(r'[0-9]{5}-[0-9]{7}-[0-9]{1}'))) {
      return "Please enter a valid CNIC number.";
    }
    return null;
  }

  // Validate input fields
  bool validateInputs() {
    bool isValid = true;

    setState(() {
      nameError = validateName(nameController.text) ?? '';
      emailError = validateEmail(emailController.text) ?? '';
      passwordError = validatePassword(passwordController.text) ?? '';
      phoneError = validatePhone(phoneController.text) ?? '';
      cnicError = validateCNIC(cnicController.text) ?? '';
    });

    if (nameError.isNotEmpty ||
        emailError.isNotEmpty ||
        passwordError.isNotEmpty ||
        phoneError.isNotEmpty ||
        cnicError.isNotEmpty) {
      isValid = false;
    }

    return isValid;
  }

  // Register button onPressed handler
  void register() async {
    if (validateInputs()) {
      print('Register Successfully');
      registerUser(); // Call the registerUser() method to store data in the database

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(
            phoneNumber: phoneController.text,
          ),
        ),
      );
    } else {
      print('Try again');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: Scaffold(
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
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            MyTextField(
                              icon: const Icon(Icons.person),
                              value: false,
                              hinttext: 'Your Name',
                              labeltext: 'Full Name',
                              prefixText: '',
                              errortext: nameError,
                              color: const Color.fromRGBO(97, 24, 33, 9),
                              type: TextInputType.text,
                              action: TextInputAction.next,
                              controller: nameController,
                              suffixIcon: null,
                            ),
                            MyTextField(
                              icon: const Icon(Icons.phone),
                              value: false,
                              hinttext: '+92-XXX-XXXXXXX',
                              labeltext: 'Phone Number',
                              prefixText: '',
                              errortext: phoneError,
                              color: const Color.fromRGBO(97, 24, 33, 9),
                              type: TextInputType.phone,
                              action: TextInputAction.next,
                              controller: phoneController,
                              suffixIcon: null,
                            ),
                            MyTextField(
                              icon: const Icon(Icons.credit_card),
                              value: false,
                              hinttext: 'XXXXX-XXXXXXX-X',
                              labeltext: 'CNIC Number',
                              prefixText: '',
                              errortext: cnicError,
                              color: const Color.fromRGBO(97, 24, 33, 9),
                              type: TextInputType.number,
                              action: TextInputAction.next,
                              controller: cnicController,
                              suffixIcon: null,
                            ),
                            MyTextField(
                              icon: const Icon(Icons.email),
                              value: false,
                              hinttext: 'abc@gmail.com',
                              labeltext: 'Email',
                              prefixText: '',
                              errortext: emailError,
                              color: const Color.fromRGBO(97, 24, 33, 9),
                              type: TextInputType.emailAddress,
                              action: TextInputAction.next,
                              controller: emailController,
                              suffixIcon: null,
                            ),
                            MyTextField(
                              icon: const Icon(Icons.lock),
                              value: !isPasswordVisible,
                              hinttext: 'Enter Password',
                              labeltext: 'Password',
                              prefixText: '',
                              errortext: passwordError,
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
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'By signing up you agree to our',
                                  style: TextStyle(
                                    color: Color.fromRGBO(97, 24, 33, 9),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Login(),
                                    //   ),
                                    // );
                                  },
                                  child: const Text(
                                    'Terms & Conditions and Privacy Policy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(97, 24, 33, 9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                register();
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
                                backgroundColor:
                                    const Color.fromRGBO(97, 24, 33, 9),
                              ),
                              child: const Text('Continue'),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already signed up?',
                                  style: TextStyle(
                                    color: Color.fromRGBO(97, 24, 33, 9),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(
                                            phoneNumber: phoneController.text),
                                      ),
                                    );
                                  },
                                  child: const Text(
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
        ),
      ),
    );
  }

  void registerUser() async {
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
        //     builder: (context) =>
        //         PhoneVerificationPage(phoneNumber: phoneController.text),
        //   ),
        // );
      }
    } catch (e) {
      print(e);
    }
  }
}
