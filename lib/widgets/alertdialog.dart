import 'package:flutter/material.dart';


Future<dynamic> showAlertDialogmsg(
    {required BuildContext context,
    required String title,
    required String content}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            icon: const Icon(
              Icons.warning,
              size: 36.0,
            ),
            iconColor: Colors.red,
            title: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            content: Text(
              content,
              softWrap: true,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),)
            ],
          ),);
}



Future<dynamic> showalertDialogactionmsg({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget>? actions,
  })  async {
   return showDialog (
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }
