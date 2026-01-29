import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Is user signed in
  bool get isSignedIn => _auth.currentUser != null;

  // User ID
  String? get userId => _auth.currentUser?.uid;

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Create/update user document in Firestore
        await _createUserDocumentIfNeeded(user);
      }

      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign in anonymously (for users who don't want to sign in)
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;

      if (user != null) {
        await _createUserDocumentIfNeeded(user);
      }

      return user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Create user document in Firestore if it doesn't exist
  Future<void> _createUserDocumentIfNeeded(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
        'isPremium': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeenAt': FieldValue.serverTimestamp(),
        'authProvider': user.isAnonymous ? 'anonymous' : 'google',
      });
    } else {
      // Update last seen
      await userDoc.update({
        'lastSeenAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Get premium status from Firestore
  Future<bool> isPremium() async {
    if (!isSignedIn) return false;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['isPremium'] ?? false;
    } catch (e) {
      print('Error getting premium status: $e');
      return false;
    }
  }

  /// Set premium status (call after successful purchase)
  Future<void> setPremium(bool isPremium) async {
    if (!isSignedIn) {
      print('User not signed in, cannot set premium status');
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'isPremium': isPremium,
        'premiumUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error setting premium status: $e');
      rethrow;
    }
  }

  /// Stream of premium status changes
  Stream<bool> get premiumStream {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['isPremium'] ?? false);
  }

  /// Delete user account and data
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user account from Firebase Auth
      await user.delete();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    if (!isSignedIn) return null;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
