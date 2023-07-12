import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      var authentication;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // if(userCredential.user != null){
        //   if(userCredential.additionalUserInfo!.isNewUser){}
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //phone signIn
  // Future<void> phoneSignIn(BuildContext context, String phoneNumber,) async{
  //   //for android & ISO
  //   await _auth.verifyPhoneNumber(phoneNumber: phoneNumber, verificationCompleted: (phoneAuthCredential) async{
  //     await _auth.signInWithCredential(credential);
  //   },
  //    verificationFailed: (e){
  //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(e.message!)));
  //   }, codeSent: ((String verificationId, int? resendToken) async {
  //     showOTPDialog

  //   }), codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)

  // }
}
