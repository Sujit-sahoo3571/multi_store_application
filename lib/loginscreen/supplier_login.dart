import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_store_application/loginscreen/supplier_signup.dart';
import 'package:multi_store_application/provider/auth_repo.dart';
import 'package:multi_store_application/screens/supplier/supplier_main_screen.dart';
import 'package:multi_store_application/screens/welcome_screen.dart';
import 'package:multi_store_application/widgets/alertdialog.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/signup_widget.dart';

class SupplierLogInScreen extends StatefulWidget {
  const SupplierLogInScreen({super.key});

  static const String signInRoutName = '/suppliers_signin';

  @override
  State<SupplierLogInScreen> createState() => _SupplierLogInScreenState();
}

class _SupplierLogInScreenState extends State<SupplierLogInScreen> {
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
                  onPressed: () {},
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
                        context, SupplierSignUpScreen.signUpRouteName);
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
              context, SupplierBottomNavigation.supplierHomeRouteName);
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
        // print(e.toString());
      }
    } else {
      stopprocessing();
      // print('invalid');
    }
  }
}
