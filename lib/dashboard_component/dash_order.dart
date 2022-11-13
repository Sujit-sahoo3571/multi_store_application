import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class DashOrderScreen extends StatelessWidget {
  const DashOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
      title: const AppbarTitle(subCategoryName: "Your Orders"),
      elevation: 0.0,
      backgroundColor: Colors.white,
      centerTitle: true,
    ));
  }
}
