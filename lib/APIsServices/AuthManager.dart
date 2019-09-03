import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseManager.dart';
import 'package:flowers_app/models/User.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInUser(String email, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<String> signUpUser(
      String name, String email, String phone, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    var dbManager = DatabaseManager();
    await dbManager.saveUserInfo(User(
        email: email,
        name: name,
        phone: phone,
        address: "No ADDRESS",
        deviceToken: ""));
    return result.user.uid;
  }

  Future<String> getCurrentUser() async {
    var user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future logOut() async {
    await this._firebaseAuth.signOut();
  }

  Future<FirebaseUser> authChanged() async {
    var user = await _firebaseAuth.onAuthStateChanged
        .firstWhere((user) => user != null);
    return user;
  }
}
