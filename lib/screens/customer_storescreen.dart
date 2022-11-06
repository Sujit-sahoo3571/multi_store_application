import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerStoreScreen extends StatelessWidget {
  const CustomerStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const AppbarTitle(subCategoryName: 'Store'),
      ),
    );
  }
}
