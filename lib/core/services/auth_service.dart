import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

/// ==========================================
/// AUTHENTICATION SERVICE
/// ==========================================
/// Handles Firebase Authentication with Google OAuth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

  // Getters for current auth state
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool get isLoggedIn => currentUser != null;

  /// Sign in with Google OAuth
  /// Returns UserCredential on success, null if user cancels
  Future<UserCredential?> signInWithGoogle() async {
    try {
      _logger.i('🔐 Starting Google Sign-In...');

      // Step 1: Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled sign-in
      if (googleUser == null) {
        _logger.w('❌ Sign-In cancelled');
        return null;
      }

      _logger.i('✅ Google user: ${googleUser.email}');

      // Step 2: Get authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      _logger.i('🎉 Firebase sign-in successful: ${userCredential.user?.email}');

      return userCredential;
    } catch (e) {
      _logger.e('❌ Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      _logger.i('👋 Signing out...');
      await _auth.signOut();
      await _googleSignIn.signOut();
      _logger.i('✅ Sign-out successful');
    } catch (e) {
      _logger.e('❌ Sign-out error: $e');
      rethrow;
    }
  }

  /// Delete user account permanently
  /// WARNING: This cannot be undone!
  Future<void> deleteAccount() async {
    try {
      _logger.i('🗑️ Deleting account...');
      await currentUser?.delete();
      await _googleSignIn.signOut();
      _logger.i('✅ Account deleted');
    } catch (e) {
      _logger.e('❌ Delete error: $e');
      rethrow;
    }
  }
}