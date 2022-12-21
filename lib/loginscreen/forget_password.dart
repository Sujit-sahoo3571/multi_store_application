import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/signup_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppbarTitle(subCategoryName: "Forget Password"),
        leading: const AppBarBackButton(),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "To reset your password \nEnter your "
                "\"Email\" and press the \"send\" Button. ",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
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
              const SizedBox(
                height: 20.0,
              ),
              MaterialGreenButton(
                  label: "send",
                  onpressed: () async {
                    if (formkey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text);

                        emailController.clear();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No User with this Email Found"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
