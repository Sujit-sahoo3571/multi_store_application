import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class SubCategory extends StatelessWidget {
  final String subCategoryName;
  final String mainCategoryName;
  const SubCategory(
      {super.key,
      required this.mainCategoryName,
      required this.subCategoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: AppbarTitle(subCategoryName: subCategoryName),
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: Center(child: Text(mainCategoryName)),
    );
  }
}
