import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  // ignore: deprecated_member_use

  // auth change user stream
  User user() {
    // ignore: deprecated_member_use
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        return null;
      } else {
        return user;
      }
    });
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
