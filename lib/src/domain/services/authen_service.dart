import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenService {
  User? get currentUser;

  // Future<User?> authStateChanges();

  Future<User?> signInWithEmail(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}
