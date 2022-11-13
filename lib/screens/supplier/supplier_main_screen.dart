import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/category_screen.dart';
// import 'package:multi_store_application/screens/customer_cart_screen.dart';
// import 'package:multi_store_application/screens/customer_profilescreen.dart';
import 'package:multi_store_application/screens/customer_storescreen.dart';
import 'package:multi_store_application/screens/customer_home_screen.dart';
import 'package:multi_store_application/screens/supplier/dashboard_screen.dart';

// ignore: must_be_immutable
class SupplierBottomNavigation extends StatefulWidget {
  int selectedIndex;
  static const supplierHomeRouteName = '/supplier_home';
  SupplierBottomNavigation({super.key, this.selectedIndex = 0});

  @override
  State<SupplierBottomNavigation> createState() =>
      _SupplierBottomNavigationState();
}

class _SupplierBottomNavigationState extends State<SupplierBottomNavigation> {
  final List<Widget> _tabs = const [
    CustomerHomeScreen(),
    CategoryScreen(),
    CustomerStoreScreen(),
    DashBoardScreen(),
    Center(
      child: Text("Upload"),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Store'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
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
