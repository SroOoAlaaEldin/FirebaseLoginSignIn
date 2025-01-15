import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {
  /////////Login With Email/////////
  static Future<void> LoginAuth(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        var pref = await SharedPreferences.getInstance();
        await pref.setString(
            "name", FirebaseAuth.instance.currentUser!.displayName!);
        pref.setString('email', email);
        pref.setBool('log', true);
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } else {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Your Email is not Verified')));
      }
    } catch (e) {
      print('$e');
    }
  }
//////////Login With Google

  static Future<UserCredential> LoginGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('name', googleUser!.displayName!);
    prefs.setString('email', googleUser.email);
    prefs.setBool('log', true);
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  ///////////SignUp
  static Future<void> SignUpAuth(
      String name, String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      await FirebaseAuth.instance.currentUser!.updateProfile(displayName: name);
      await FirebaseAuth.instance.currentUser!.reload();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('SignUp is Succeffull ,Please Verifiy Your Email')));
    } catch (e) {
      print('$e');
    }
  }

  static Future<void> forgetPassword(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            TextEditingController email = TextEditingController();
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Please Enter Your Email'),
              content: TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // prefixIcon: Icon(Icons.person),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please Enter your email address'),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Password reset in the email address,Check Email'),
                        backgroundColor: Colors.green,
                      ));
                    }
                  },
                  child: Text('Reset'),
                ),
                TextButton(onPressed: () {}, child: Text('Cancel')),
              ],
            );
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An ERROR Has Accourd , Please Try Again'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
