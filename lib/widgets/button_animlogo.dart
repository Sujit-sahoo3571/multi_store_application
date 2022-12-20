import 'dart:math';

import 'package:flutter/material.dart';

class ContainerYellowButton extends StatelessWidget {
  final String label;
  final void Function()? onpressed;
  final double width;
  const ContainerYellowButton({
    Key? key,
    required this.label,
    required this.width,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.yellow,
      ),
      child: MaterialButton(
        onPressed: onpressed,
        child: Text(label),
      ),
    );
  }
}

class MaterialYellowButton extends StatelessWidget {
  final String label;
  final void Function()? onpressed;
  final double elevation;
  final double width;
  const MaterialYellowButton({
    Key? key,
    required this.label,
    this.width = 0.25,
    required this.onpressed,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(50.0),
      color: Colors.yellow,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * width,
        onPressed: onpressed,
        child: Text(label),
      ),
    );
  }
}

// green button
class MaterialGreenButton extends StatelessWidget {
  final String label;
  final void Function()? onpressed;
  final double elevation;
  final double width;
  const MaterialGreenButton({
    Key? key,
    required this.label,
    this.width = 0.25,
    required this.onpressed,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(50.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * width,
        onPressed: onpressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// animated logo and Google icon buttons

class GoogleIconButton extends StatelessWidget {
  final String image;
  final String label;
  final void Function()? onpressed;
  const GoogleIconButton({
    Key? key,
    required this.image,
    required this.label,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Column(
        children: [
          SizedBox(
              height: 48.0,
              width: 48.0,
              child: Image(image: AssetImage(image))),
          Text(
            label,
            style: const TextStyle(fontSize: 11.0, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: ((context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      }),
      child: const Image(
        height: 40.0,
        image: AssetImage('assets/images/moon.png'),
      ),
    );
  }
}
