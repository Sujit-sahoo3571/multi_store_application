import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

import 'customer_main_screen.dart';

class HotDeals extends StatelessWidget {
  final bool fromONBoard;
  final int? maxdiscount;
  const HotDeals({super.key, required this.fromONBoard, this.maxdiscount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const AppbarTitle(subCategoryName: "Hot Deals "),
        leading: IconButton(
          onPressed: () {
            //
            Navigator.pushReplacementNamed(
                context, CustomerBottomNavigation.customerHomeRouteName);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Image.asset(
        "assets/images/sales.png",
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
