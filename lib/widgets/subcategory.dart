import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/home_products_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategory extends StatefulWidget {
  final String subCategoryName;
  final String mainCategoryName;
  const SubCategory(
      {super.key,
      required this.mainCategoryName,
      required this.subCategoryName});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productstream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.mainCategoryName)
        .where('subcategory', isEqualTo: widget.subCategoryName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: AppbarTitle(subCategoryName: widget.subCategoryName),
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productstream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong !"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "This category items are not available for now . ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 18.0),
              ),
            );
          }
          return StaggeredGridView.countBuilder(
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ProductsModelHomeW(products: snapshot.data!.docs[index]);
              },
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1));
        },
      ),
    );
  }
}
