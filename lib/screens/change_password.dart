import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:multi_store_application/provider/auth_repo.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldtextController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool checkPassword = true;

  @override
  void dispose() {
    // TODO: implement dispose
    oldtextController.dispose();
    newpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const AppbarTitle(subCategoryName: "Change Password"),
        leading: const AppBarBackButton(),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Change Your Password here . ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: oldtextController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your password";
                    }
                    return null;
                  },
                  decoration: decorationBorder.copyWith(
                    label: const Text("Old Password"),
                    hintText: "your current password",
                    errorText:
                        !checkPassword ? " Enter correct password" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a new password";
                      } else {
                        return null;
                      }
                    },
                    controller: newpasswordController,
                    decoration: decorationBorder.copyWith(
                      label: const Text("New Password"),
                      hintText: "Enter a new password",
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Re-Enter new password";
                    } else if (value != newpasswordController.text) {
                      return "password mismatch check again";
                    }
                    return null;
                  },
                  decoration: decorationBorder.copyWith(
                    label: const Text("Repeat Password"),
                    hintText: "Re-Enter new password",
                  ),
                ),

//password validator
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  child: FlutterPwValidator(
                      controller: newpasswordController,
                      minLength: 6,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      specialCharCount: 1,
                      width: 400,
                      height: 150,
                      onSuccess: () {},
                      onFail: () {}),
                ),
// save button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: MaterialGreenButton(
                      label: "Save",
                      onpressed: () async {
                        print(FirebaseAuth.instance.currentUser!);
                        if (formKey.currentState!.validate()) {
                          // checkpassword is true or false ; from firebase 
                          checkPassword = await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email!,
                              oldtextController.text);
                          setState(() {});
                          checkPassword
                              ? await AuthRepo.updatePassword(
                                      newpasswordController.text.trim())
                                  .whenComplete(() {
                                  formKey.currentState!.reset();
                                  oldtextController.clear();
                                  newpasswordController.clear();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Password update successfully ",
                                    ),
                                    backgroundColor: Colors.green,
                                  ));
                                }).whenComplete(() => Navigator.pop(context))
                              // print("valid old password")
                              : print("not valid old password ");
                          print("Form Valid");
                        } else {
                          print("Form Invalid");
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final decorationBorder = InputDecoration(
  label: const Text("text"),
  hintText: "text",
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide()),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(
      color: Colors.purple,
    ),
  ),
);
