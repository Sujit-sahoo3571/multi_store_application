import 'package:flutter/material.dart';

class ListTileonTap extends StatelessWidget {
  final String lable;
  final void Function()? onpressed;
  final IconData icon;
  const ListTileonTap({
    Key? key,
    required this.lable,
    this.onpressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onpressed,
      leading: Icon(icon),
      title: Text(lable),
    );
  }
}

class AccountInfoText extends StatelessWidget {
  final String title;
  const AccountInfoText({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50.0,
            height: 30.0,
            child: Divider(
              height: 10.0,
              color: Colors.amber,
              thickness: 5.0,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20.0, fontFamily: 'Poppins', color: Colors.grey),
          ),
          const SizedBox(
            width: 50.0,
            height: 30.0,
            child: Divider(
              height: 30.0,
              color: Colors.amber,
              thickness: 5.0,
            ),
          ),
        ],
      ),
    );
  }
}
