import 'package:flutter/material.dart';
import 'package:multi_store_application/loginscreen/customer_login.dart';
import 'package:multi_store_application/loginscreen/customer_signup_page.dart';
import 'package:multi_store_application/loginscreen/supplier_login.dart';
import 'package:multi_store_application/loginscreen/supplier_signup.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/provider/wishlist_product.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/screens/supplier/supplier_main_screen.dart';
import 'package:multi_store_application/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()), 
  ], child: const MyApp()));
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
      initialRoute: WelcomeScreen.welcomeRouteName,
      routes: {
        WelcomeScreen.welcomeRouteName: (context) => const WelcomeScreen(),
        CustomerBottomNavigation.customerHomeRouteName: (context) =>
            CustomerBottomNavigation(),
        SupplierBottomNavigation.supplierHomeRouteName: (context) =>
            SupplierBottomNavigation(),
        CustomerLogInScreen.signInRoutName: (context) =>
            const CustomerLogInScreen(),
        CustomerSignUpScreen.signUpRouteName: (context) =>
            const CustomerSignUpScreen(),
        SupplierLogInScreen.signInRoutName: (context) =>
            const SupplierLogInScreen(),
        SupplierSignUpScreen.signUpRouteName: (context) =>
            const SupplierSignUpScreen(),
      },
    );
  }
}
