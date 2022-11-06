import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/category_screen.dart';
import 'package:multi_store_application/screens/customer_cart_screen.dart';
import 'package:multi_store_application/screens/customer_profilescreen.dart';
import 'package:multi_store_application/screens/customer_storescreen.dart';
import 'package:multi_store_application/screens/customer_home_screen.dart';

// ignore: must_be_immutable
class CustomerBottomNavigation extends StatefulWidget {
  int selectedIndex;

  CustomerBottomNavigation({super.key, this.selectedIndex = 0});

  @override
  State<CustomerBottomNavigation> createState() =>
      _CustomerBottomNavigationState();
}

class _CustomerBottomNavigationState extends State<CustomerBottomNavigation> {
  final List<Widget> _tabs = const [
    CustomerHomeScreen(),
    CategoryScreen(),
    CustomerStoreScreen(),
    CustomerCartScreen(),
    CustomerProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        currentIndex: widget.selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Store'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
