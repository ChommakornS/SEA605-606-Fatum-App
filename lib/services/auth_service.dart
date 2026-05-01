import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Added
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GoogleSignIn _googleSignIn = kIsWeb
    ? GoogleSignIn()
    : GoogleSignIn(serverClientId: '682229756288-h69c2mlhqad99nd2r9ii3hfbfrrt25ep.apps.googleusercontent.com');

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password, {String? username}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (username != null && username.isNotEmpty) {
      await credential.user?.updateDisplayName(username);
    }
    return credential;
  }


  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Web uses Firebase popup — no google_sign_in needed
      return _auth.signInWithPopup(GoogleAuthProvider());
    }

    // Android / iOS: native Google Sign-In.
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    // Disconnect Google (if signed in via Google) — ignore errors for email users
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    // Sign out from Firebase
    await _auth.signOut();
  }
}
