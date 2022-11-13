import 'package:flutter/material.dart';

class CameraIconW extends StatelessWidget {
  final IconData icon;
  final void Function()? onpressed;
  final bool istopcrop;
  const CameraIconW({
    Key? key,
    required this.icon,
    this.onpressed,
    this.istopcrop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: 55.0,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.only(
          topLeft: istopcrop ? const Radius.circular(20.0) : Radius.zero,
          topRight: istopcrop ? const Radius.circular(20.0) : Radius.zero,
          bottomLeft: istopcrop ? Radius.zero : const Radius.circular(20.0),
          bottomRight: istopcrop ? Radius.zero : const Radius.circular(20.0),
        ),
      ),
      child: IconButton(
          onPressed: onpressed,
          icon: Icon(
            icon,
            size: 35.0,
          )),
    );
  }
}

class AlreadyanAccountW extends StatelessWidget {
  final String text;
  final String actionText;
  final void Function()? onpressed;
  const AlreadyanAccountW({
    Key? key,
    required this.text,
    this.onpressed,
    required this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16.0),
          ),
          InkWell(
            onTap: onpressed,
            child: Text(
              actionText,
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SignupTitleW extends StatelessWidget {
  final String textName;
  final IconData icon;
  final void Function()? onpressed;
  const SignupTitleW({
    Key? key,
    required this.textName,
    required this.onpressed,
    this.icon = Icons.home_work,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textName,
          style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              fontSize: 30.0),
        ),
        IconButton(
            onPressed: onpressed,
            icon: Icon(
              icon,
              size: 45.0,
              color: Colors.blue,
            ))
      ],
    );
  }
}

final decorationBorder = InputDecoration(
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide()),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(
      color: Colors.purple,
    ),
  ),
);


//email validator string override 
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.])([a-z]{2,3})$')
        .hasMatch(this);
  }
}