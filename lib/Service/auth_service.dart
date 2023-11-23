// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/Helper/helper_function.dart';
import 'package:eduvista/db/firebase.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//login
  Future loginUserAccount(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//signUp
  Future createUserAccount(UserDetails userDetails) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: userDetails.email, password: userDetails.password))
          .user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        FirebaseDatabase(uid: user.uid).setUserDataFirebase(userDetails);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gauth = await guser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gauth.accessToken, idToken: gauth.idToken);

      // Sign in with Firebase using the Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Access the user information
      User? user = userCredential.user;

      // Navigate to the home page and pass the user data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoardScrn(user: user),
        ),
      );
    } catch (e) {
      print("Error signing in with Google: $e");
      newshowSnackbar(context, 'Google Sign In', 'Error signing in with Google',
          ContentType.failure);
    }
  }

//   Future<void> signInWithFacebook(BuildContext context) async {
//     try {
//       final LoginResult result =
//           await FacebookAuth.instance.login(); // Perform Facebook login

//       if (result.status == LoginStatus.success) {
//         final AccessToken? accessToken = result.accessToken;

//         if (accessToken != null) {
//           final OAuthCredential credential =
//               FacebookAuthProvider.credential(accessToken.token);

//           // Sign in with Firebase using the Facebook credentials
//           UserCredential userCredential =
//               await FirebaseAuth.instance.signInWithCredential(credential);

//           // Access the user information
//           User? user = userCredential.user;

//           // Navigate to the home page and pass the user data
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DashBoardScrn(user: user),
//             ),
//           );
//         } else {
//           print("Facebook login failed: No access token received.");
//         }
//       } else if (result.status == LoginStatus.cancelled) {
//         // Handle the case where the user canceled the Facebook login
//         print("Facebook login canceled.");
//       } else {
//         print("Facebook login failed: ${result.message}");
//       }
//     } catch (e) {
//       print("Error signing in with Facebook: $e");
//     }
//   }

  Future<UserCredential> signInWithFacebook(BuildContext context) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile', 'user_birthday']);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    var userData = await FacebookAuth.instance.getUserData();
    var useremail = userData['email'];
    print(useremail);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
