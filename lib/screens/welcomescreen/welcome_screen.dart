import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/yellow_button.dart';

const kcolorizedColors = [
  Colors.purple,
  Colors.yellow,
  Colors.blue,
  Colors.red,
];
const ktextStyle = TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                              onpressed: (() {}),
                            ),
                            ContainerYellowButton(
                              label: 'LogIn',
                              width: 0.25,
                              onpressed: (() {}),
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
                          onpressed: (() {}),
                        ),
                        ContainerYellowButton(
                          label: 'LogIn',
                          width: 0.25,
                          onpressed: (() {}),
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
                      GoogleIconButton(
                          image: 'assets/images/profile.png',
                          label: 'Guest',
                          onpressed: () {}),
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
