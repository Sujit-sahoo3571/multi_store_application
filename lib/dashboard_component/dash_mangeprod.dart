import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class DashMangaeProduct extends StatelessWidget {
  const DashMangaeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: const AppBarBackButton(),
      title: const AppbarTitle(subCategoryName: "Manage Products"),
      elevation: 0.0,
      backgroundColor: Colors.white,
      centerTitle: true,
    ));
  }
}
