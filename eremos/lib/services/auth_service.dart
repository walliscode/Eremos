import 'package:eremos/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign up a new user
  static Future<AppUser?> signUp(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        return AppUser(
          // bang is added to the uid and email properties to avoid null safety issues
          // we are telling the code that is guarenteed that the user is not null
          uid: credential.user!.uid,
          email: credential.user!.email!,
        );
      }
    } catch (e) {
      // any errors will automatically return null so no undefined behaviour occurs on login
      return null;
    }

    return null;
  }

  // sign in a user
  static Future<AppUser?> signIn(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
        );
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  // sign  users out
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
