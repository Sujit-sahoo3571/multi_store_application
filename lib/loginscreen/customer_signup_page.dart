import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_application/loginscreen/customer_login.dart';
import 'package:multi_store_application/screens/welcomescreen/welcome_screen.dart';
import 'package:multi_store_application/widgets/alertdialog.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/signup_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({super.key});
  static const signUpRouteName = '/customer_signup';

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowPassword = false;
  late String name;
  late String email;
  late String password;
  late String profileimage;
  bool isprocessing = false;
  late String _uid;
  dynamic errorMessage;
  final ImagePicker _picker = ImagePicker();

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  XFile? _image;
  void _pickImageFromCamera() async {
    try {
      final XFile? cameraImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 85);
      setState(() {
        _image = cameraImage;
      });
    } catch (e) {
      errorMessage = e;
    }
  }

  void _pickImageFromGallery() async {
    try {
      final XFile? galleryImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 85);
      setState(() {
        _image = galleryImage;
      });
    } catch (e) {
      errorMessage = e;
    }
  }

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
              children: [
                SignupTitleW(
                  textName: "SignUp",
                  onpressed: () {
                    Navigator.canPop(context)
                        ? Navigator.of(context).pop()
                        : Navigator.pushReplacementNamed(
                            context, WelcomeScreen.welcomeRouteName);
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 30.0, bottom: 20.0, top: 10.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 55.0,
                        backgroundImage: _image == null
                            ? null
                            : FileImage(
                                io.File(_image!.path),
                              ),
                      ),
                    ),
                    Column(
                      children: [
                        CameraIconW(
                            istopcrop: true,
                            icon: Icons.camera_alt,
                            onpressed: () => _pickImageFromCamera()),
                        const SizedBox(
                          height: 8.0,
                        ),
                        CameraIconW(
                          icon: Icons.image,
                          onpressed: () {
                            _pickImageFromGallery();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim().length <= 2) {
                        return "Please enter a valid name";
                      }
                      return null;
                    },
                    style: const TextStyle(letterSpacing: 1.5),
                    decoration: decorationBorder.copyWith(
                      label: const Text("Name"),
                      hintText: "Enter Your Name",
                    ),
                  ),
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
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Colors.grey,
                        )),
                  ),
                ),
                AlreadyanAccountW(
                  text: "already have an account? ",
                  actionText: "Log In",
                  onpressed: () {
                    Navigator.pushReplacementNamed(
                        context, CustomerLogInScreen.signInRoutName);
                  },
                ),
                isprocessing
                    ? const CircularProgressIndicator()
                    : MaterialYellowButton(
                        label: "SIGN UP",
                        onpressed: () {
                          signUp();
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

  void signUp() async {
    setState(() {
      isprocessing = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (_image != null) {
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          //TODO
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('customerimage/$email.jpg');

          await ref.putFile(io.File(_image!.path));

          profileimage = await ref.getDownloadURL();

          _uid = FirebaseAuth.instance.currentUser!.uid;

          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'phone': '',
            'profileimage': profileimage,
            'address': '',
            'cid': _uid,
          });

          _formKey.currentState!.reset();
          setState(() {
            _image = null;
          });

          stopprocessing();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(
              context, CustomerLogInScreen.signInRoutName);
          //above call signin
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showAlertDialogmsg(
                context: context,
                title: "Weak Password!",
                content: "The password provided is too weak.");
          } else if (e.code == 'email-already-in-use') {
            stopprocessing();
            showAlertDialogmsg(
                context: context,
                title: "Email Exists! ",
                content: "The account already exists for that email.");
          }
        } catch (e) {
          stopprocessing();
          showAlertDialogmsg(
              context: context, title: "Error", content: e.toString());
        }
      } else {
        stopprocessing();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Pick an image first !!! ",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )));
      }
    } else {
      print('invalid');
      stopprocessing();
      // TODO
    }
  }
}
