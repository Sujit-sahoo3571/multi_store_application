import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store_application/loginscreen/customer_signup_page.dart';
import 'package:multi_store_application/loginscreen/forget_password.dart';
import 'package:multi_store_application/provider/auth_repo.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/screens/onboarding_screen.dart';
import 'package:multi_store_application/screens/welcome_screen.dart';
import 'package:multi_store_application/widgets/alertdialog.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/signup_widget.dart';

class CustomerLogInScreen extends StatefulWidget {
  const CustomerLogInScreen({super.key});

  static const String signInRoutName = '/customer_signin';

  @override
  State<CustomerLogInScreen> createState() => _CustomerLogInScreenState();
}

class _CustomerLogInScreenState extends State<CustomerLogInScreen> {
  bool docExists = false;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  // check if user exist
  Future<bool> docIfExists(String uid) async {
    try {
      var doc = await customers.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

// google signin
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      // _uid = FirebaseAuth.instance.currentUser!.uid;
      print(googleUser!.id);
      print(googleUser);
      print(user);

      // check doc exist
      docExists = await docIfExists(user.uid);

      !docExists
          ? await customers.doc(user.uid).set({
              'name': user.displayName,
              'email': user.email,
              'phone': '',
              'profileimage': user.photoURL,
              'address': '',
              'cid': user.uid,
              'role': 'user',
            }).whenComplete(() => navigate())
          : navigate();
    });
  }

//google signin

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowPassword = false;
  late String email;
  late String password;
  bool isprocessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SignupTitleW(
                  textName: "Login",
                  onpressed: () {
                    Navigator.canPop(context)
                        ? Navigator.of(context).pop()
                        : Navigator.pushReplacementNamed(
                            context, WelcomeScreen.welcomeRouteName);
                  },
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter an email address";
                      } else if (!value.isValidEmail()) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(letterSpacing: 1.5),
                    decoration: decorationBorder.copyWith(
                      label: const Text("Email"),
                      hintText: "Enter Your Email",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter a password ";
                      } else if (value.trim().length <= 6) {
                        return "Password must be greater than 6 letters";
                      }
                      return null;
                    },
                    obscureText: !isShowPassword,
                    style: const TextStyle(
                      letterSpacing: 1.5,
                    ),
                    decoration: decorationBorder.copyWith(
                        label: const Text("Password"),
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                          icon: Icon(isShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          color: Colors.grey,
                        )),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgetPasswordScreen()));
                  },
                  child: const Text(
                    "Forget Password ? ",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                  ),
                ),
                AlreadyanAccountW(
                  text: "Register a new account? ",
                  actionText: "Sign Up",
                  onpressed: () {
                    Navigator.pushReplacementNamed(
                        context, CustomerSignUpScreen.signUpRouteName);
                  },
                ),
                isprocessing
                    ? const CircularProgressIndicator()
                    : MaterialYellowButton(
                        label: "Log In",
                        onpressed: () {
                          logIn();
                        },
                        width: 0.4,
                        elevation: 8.0,
                      ),
                divider(),
                googleButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void stopprocessing() {
    setState(() {
      isprocessing = false;
    });
  }

  void logIn() async {
    // await AuthRepo.emailVerification();
    setState(() {
      isprocessing = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reload();

        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          _formKey.currentState!.reset();

          stopprocessing();

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(
              context, CustomerBottomNavigation.customerHomeRouteName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Check Your Inbox To Verify Email."),
            backgroundColor: Colors.green,
          ));

          stopprocessing();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          stopprocessing();
          // print('No user found for that email.');
          showAlertDialogmsg(
              context: context,
              title: "No User Found!",
              content: "No user found for that email.");
        } else if (e.code == 'wrong-password') {
          stopprocessing();
          // print('Wrong password provided for that user.');
          showAlertDialogmsg(
              context: context,
              title: "Wrong Password",
              content: "Wrong password provided for that user.");
        }
      } catch (e) {
        stopprocessing();
        Center(child: Text(e.toString()));
      }
    } else {
      stopprocessing();
      // print('invalid');
    }
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 80.0,
            child: Divider(
              height: 20.0,
              thickness: 2.0,
              color: Colors.grey,
            ),
          ),
          Text(
            " OR ",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 80.0,
            child: Divider(
              thickness: 2.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleButton() {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
      child: MaterialButton(
        onPressed: () async {
          await signInWithGoogle();
        },
        child: Row(
          children: const [
            Icon(
              FontAwesomeIcons.google,
              size: 30.0,
              color: Colors.red,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              " SignIn with Google",
              style: TextStyle(
                color: Colors.redAccent,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigate() {
    Navigator.pushReplacementNamed(
        context,
        // CustomerBottomNavigation.customerHomeRouteName
        OnBoardingScreen.onboarding);
  }
}
