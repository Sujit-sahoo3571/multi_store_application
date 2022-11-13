import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerWishListScreen extends StatelessWidget {
  const CustomerWishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppbarTitle(subCategoryName: "WishList"),
        leading: const AppBarBackButton(),
      ),
      body: const Center(child: Text("Wishlist")),
    );
  }
}
