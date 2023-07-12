import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:votingapp/otp_page/otp_page.dart';

class PhoneVerification extends StatelessWidget {
  final String phoneNumber;
  static String verify = "";

  const PhoneVerification({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/otp.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 25),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "We need to verify the phone number to continue.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  "Phone Number: $phoneNumber",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
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
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "Phone Number: $phoneNumber",
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          PhoneVerification.verify = verificationId;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtpPage(phoneNumber: phoneNumber),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text("Send the code"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneVerificationPage extends StatefulWidget {
  final String userId;

  const PhoneVerificationPage({required this.userId});

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: phoneNumber != null
          ? PhoneVerification(phoneNumber: phoneNumber!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
