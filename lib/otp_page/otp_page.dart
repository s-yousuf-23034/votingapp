import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:votingapp/phone_verification/phone_verification.dart';
import 'package:votingapp/profile.dart';

class OtpPage extends StatefulWidget {
  // final String username;
  // final bool isAdmin;
//required this.username, required this.isAdmin,
  OtpPage({super.key, required String phoneNumber});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/otp.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(97, 24, 33, 9)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter OTP sent to your phone number',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(97, 24, 33, 9)),
                ),
                const SizedBox(height: 40),
                Pinput(
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive code?",
                        style: TextStyle(
                          color: Color.fromRGBO(97, 24, 33, 9),
                          // fontWeight: FontWeight.bold,
                        )),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(97, 24, 33, 9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: PhoneVerification.verify,
                              smsCode: code);

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ));
                    } catch (e) {
                      print("Wrong OTP!");
                    };
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
                  child: const Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),

      // },
      //),
    );
  }
}
