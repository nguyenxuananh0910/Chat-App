import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenRepo implements AuthenService {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  // Future<User?> authStateChanges() async {
  //   _firebaseAuth.authStateChanges();
  // }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }
}
