import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  Future<User?> signInWithGoogle() async {
    // Use singleton instance for google_sign_in 7.x
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      // 1. Initialize
      await googleSignIn.initialize();

      // 2. Authenticate
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate(scopeHint: ['email']);
      if (googleUser == null) {
        debugPrint('User cancelled the sign-in');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Sign-in cancelled by user.')),
        // );
      }

      // 3. Get authorization for Firebase scopes if needed
      final authClient = googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      // 4. Sign in with Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleUser?.authentication.idToken,
      );

      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      return result.user;

    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth error: ${e.code} - ${e.message}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Firebase error: ${e.message}')),
      // );
      return null;
    } on Exception catch (e, stack) {
      debugPrint('General error: $e');
      debugPrint('Stack trace: $stack');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Sign-in failed: $e')),
      // );
      return null;
    }

    
  }

}
