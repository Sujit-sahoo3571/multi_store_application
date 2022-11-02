import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/customer_home_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Multi Store Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CustomerHomeScreen());
  }
}
