import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppbarTitle(subCategoryName: "Orders"),
        leading: const AppBarBackButton(),
      ),
      body: const Center(child: Text("orders")),
    );
  }
}
