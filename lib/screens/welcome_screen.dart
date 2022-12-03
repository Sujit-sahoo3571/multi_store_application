import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/loginscreen/customer_login.dart';
import 'package:multi_store_application/loginscreen/customer_signup_page.dart';
import 'package:multi_store_application/loginscreen/supplier_login.dart';
import 'package:multi_store_application/loginscreen/supplier_signup.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';

const kcolorizedColors = [
  Colors.purple,
  Colors.yellow,
  Colors.blue,
  Colors.red,
];
const ktextStyle = TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const welcomeRouteName = '/welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  // CollectionReference customers =
  //     FirebaseFirestore.instance.collection('customers');
  CollectionReference anonymus =
      FirebaseFirestore.instance.collection('anonymus');

  late String _uid;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgimage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60.0,
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText('MULTI STORE',
                        textStyle: ktextStyle, colors: kcolorizedColors),
                    ColorizeAnimatedText(' WELCOME ',
                        textStyle: ktextStyle, colors: kcolorizedColors),
                  ],
                  repeatForever: true,
                ),
              ),
              const SizedBox(
                height: 120.0,
                width: 200.0,
                child: Image(
                  image: AssetImage(
                    "assets/images/bird.jpg",
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText("BUY"),
                      RotateAnimatedText("SELL"),
                      RotateAnimatedText("SHOP"),
                      RotateAnimatedText("MULTI STORE"),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                          ),
                          color: Colors.white54,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Supplier\'s only',
                            style: TextStyle(
                                color: Colors.yellowAccent, fontSize: 22.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 60.0,
                        width: screensize.width * 0.8,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                          ),
                          color: Colors.white54,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedLogo(controller: _controller),
                            ContainerYellowButton(
                              label: 'SignUp',
                              width: 0.25,
                              onpressed: () {
                                Navigator.pushReplacementNamed(context,
                                    SupplierSignUpScreen.signUpRouteName);
                              },
                            ),
                            ContainerYellowButton(
                              label: 'LogIn',
                              width: 0.25,
                              onpressed: () {
                                Navigator.pushReplacementNamed(context,
                                    SupplierLogInScreen.signInRoutName);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60.0,
                    width: screensize.width * 0.8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                      color: Colors.white54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ContainerYellowButton(
                          label: 'SignUp',
                          width: 0.25,
                          onpressed: () => Navigator.pushReplacementNamed(
                              context, CustomerSignUpScreen.signUpRouteName),
                        ),
                        ContainerYellowButton(
                          label: 'LogIn',
                          width: 0.25,
                          onpressed: () {
                            Navigator.pushReplacementNamed(
                                context, CustomerLogInScreen.signInRoutName);
                          },
                        ),
                        AnimatedLogo(controller: _controller),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  height: 70.0,
                  decoration: const BoxDecoration(color: Colors.white30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleIconButton(
                        image: 'assets/images/googleicon.png',
                        label: "Google",
                        onpressed: () {},
                      ),
                      GoogleIconButton(
                        image: 'assets/images/facebookicon.png',
                        label: 'Facebook',
                        onpressed: () {},
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : GoogleIconButton(
                              image: 'assets/images/profile.png',
                              label: 'Guest',
                              onpressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = FirebaseAuth.instance.currentUser!.uid;
                                  await anonymus.doc(_uid).set({
                                    'name': '',
                                    'email': '',
                                    'phone': '',
                                    'profileimage': '',
                                    'address': '',
                                    'cid': _uid,
                                    'role': 'user',
                                  });
                                });

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacementNamed(
                                    context,
                                    CustomerBottomNavigation
                                        .customerHomeRouteName);
                                isLoading = false;
                              }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
