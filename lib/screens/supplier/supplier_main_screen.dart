import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/category_screen.dart';
// import 'package:multi_store_application/screens/customer_cart_screen.dart';
// import 'package:multi_store_application/screens/customer_profilescreen.dart';
import 'package:multi_store_application/screens/customer_storescreen.dart';
import 'package:multi_store_application/screens/customer_home_screen.dart';
import 'package:multi_store_application/screens/supplier/dashboard_screen.dart';
import 'package:multi_store_application/screens/supplier/upload_screen.dart';

// ignore: must_be_immutable
class SupplierBottomNavigation extends StatefulWidget {
  int selectedIndex;
  static const supplierHomeRouteName = '/supplier_home';
  SupplierBottomNavigation({super.key, this.selectedIndex = 0}); // TODO

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
    UploadProductScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("sid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("deliverystatus", isEqualTo: "preparing")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            body: _tabs[widget.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              currentIndex: widget.selectedIndex,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: 'Category'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.shop), label: 'Store'),
                BottomNavigationBarItem(
                    icon: Badge(
                        showBadge: snapshot.data!.docs.isEmpty ? false : true,
                        padding: const EdgeInsets.all(2.0),
                        badgeColor: Colors.yellow,
                        badgeContent: Text(
                          snapshot.data!.docs.length.toString(),
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        child: const Icon(Icons.dashboard)),
                    label: 'Dashboard'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.upload), label: 'Upload'),
              ],
              onTap: (value) {
                setState(() {
                  widget.selectedIndex = value;
                });
              },
            ),
          );
        });
  }
}
