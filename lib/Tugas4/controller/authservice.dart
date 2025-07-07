import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();
        return _auth.currentUser;
      } else {
        return result.user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

}