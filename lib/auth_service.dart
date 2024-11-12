import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          print('Registration error: The email address is already in use.');
          break;
        case 'invalid-email':
          print('Registration error: The email address is not valid.');
          break;
        case 'operation-not-allowed':
          print('Registration error: Email/password accounts are not enabled.');
          break;
        case 'weak-password':
          print('Registration error: The password is too weak.');
          break;
        default:
          print('Registration error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Registration error: An unexpected error occurred. ${e.toString()}');
      return null;
    }
  }

  // Sign in user with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print('Sign-in error: No user found for that email.');
          break;
        case 'wrong-password':
          print('Sign-in error: Wrong password provided.');
          break;
        case 'invalid-email':
          print('Sign-in error: The email address is not valid.');
          break;
        default:
          print('Sign-in error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Sign-in error: An unexpected error occurred. ${e.toString()}');
      return null;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
