import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
    required this.subCategoryName,
  }) : super(key: key);

  final String subCategoryName;

  @override
  Widget build(BuildContext context) {
    return Text(
      subCategoryName.toUpperCase(),
      style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontFamily: 'Poppins',
          letterSpacing: 1.2),
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ));
  }
}
