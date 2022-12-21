import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  // signup with email
  static Future<void> signupWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //login with email
  static Future<void> signInWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //email verification

  static Future<void> emailVerification() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print("Error send in email varification : $e");
    }
  }

  //get uid
  static get uid {
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }

  //update storename and logo
  static Future<void> updateStoreName(storename, storelogo) async {
    User user = FirebaseAuth.instance.currentUser!;

    await user.updateDisplayName(storename);
    await user.updatePhotoURL(storelogo);
  }

  //reload
  static Future<void> reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }
  //check the password for email

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);

      return credentialResult != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

 static Future<void> updatePassword(newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }
}
