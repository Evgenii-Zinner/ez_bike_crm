import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service responsible for handling user authentication via Firebase and Google Sign-In.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Returns the currently authenticated [User], or null if none exists.
  User? get currentUser => _auth.currentUser;

  /// Returns true if there is a currently authenticated user.
  bool get isLoggedIn => _auth.currentUser != null;

  /// Initiates the Google Sign-In flow.
  ///
  /// Returns the authenticated [User] on success, or null on failure.
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In UI.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain authentication details from the account.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a Firebase credential from the Google tokens.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase using the credential.
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  /// Signs the user out from both Firebase and Google.
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// Returns a stream of [User] auth state changes.
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
