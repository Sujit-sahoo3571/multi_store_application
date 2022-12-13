import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/screens/category_screen.dart';
import 'package:multi_store_application/screens/customer_cart_screen.dart';
import 'package:multi_store_application/screens/customer_profilescreen.dart';
import 'package:multi_store_application/screens/customer_storescreen.dart';
import 'package:multi_store_application/screens/customer_home_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomerBottomNavigation extends StatefulWidget {
  int selectedIndex;
  static const customerHomeRouteName = '/customer_home';

  CustomerBottomNavigation({super.key, this.selectedIndex = 0});

  @override
  State<CustomerBottomNavigation> createState() =>
      _CustomerBottomNavigationState();
}

class _CustomerBottomNavigationState extends State<CustomerBottomNavigation> {
  final List<Widget> _tabs = [
    const CustomerHomeScreen(),
    const CategoryScreen(),
    const CustomerStoreScreen(),
   const CustomerCartScreen(),
    CustomerProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        currentIndex: widget.selectedIndex,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          const BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Store'),
          BottomNavigationBarItem(
              icon: Badge(
                  showBadge:
                      context.read<Cart>().getItems.isEmpty ? false : true,
                  padding: const EdgeInsets.all(2.0),
                  badgeColor: Colors.yellow,
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  child: const Icon(Icons.shopping_cart)),
              // Icon(Icons.shopping_cart)

              label: 'Cart'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (value) {
          setState(() {
            widget.selectedIndex = value;
          });
        },
      ),
    );
  }
}
