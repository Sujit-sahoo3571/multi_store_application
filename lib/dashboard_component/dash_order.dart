import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

import '../sellerorder/delivered_order.dart';
import '../sellerorder/preparing_order.dart';
import '../sellerorder/shipping_order.dart';

class DashOrderScreen extends StatelessWidget {
  const DashOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          title: const AppbarTitle(subCategoryName: "Orders"),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.yellow,
              indicatorWeight: 8.0,
              tabs: [
                RepeatedTabBar(label: "Preparing"),
                RepeatedTabBar(label: "Shipping"),
                RepeatedTabBar(label: "Delivered"),
              ]),
        ),
        body: const TabBarView(children: [
          Preparing(),
          Shipping(),
          Delivered(),
        ]),
      ),
    );
  }
}

class RepeatedTabBar extends StatelessWidget {
  final String label;
  const RepeatedTabBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
          child: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      )),
    );
  }
}
