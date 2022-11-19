import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_application/Modelwidgets/home_products_widgets.dart';
import 'package:multi_store_application/minor_screen/full_view_image.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/listtile_widget.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic prodlist;
  const ProductDetailScreen({super.key, required this.prodlist});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<dynamic> productimage = widget.prodlist['productimages'];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productstream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.prodlist['maincategory'])
        .where('subcategory', isEqualTo: widget.prodlist['subcategory'])
        .snapshots();
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  FullScreenView(imageList: productimage,))),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                          itemCount: productimage.length,
                          itemBuilder: (context, index) => Image(
                            image: NetworkImage(productimage[index]),
                          ),
                          pagination: const SwiperPagination(
                              builder: SwiperPagination.dots),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15.0,
                      top: 20.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ),
                    ),
                    Positioned(
                      right: 15.0,
                      top: 20.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.share)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 50),
                  child: Text(
                    widget.prodlist['productname'],
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        " Rs. ${widget.prodlist['price'].toStringAsFixed(2)} "),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Text(
                    ' ${widget.prodlist['instock']} No. of Pieces Available on Store. '),
                const AccountInfoText(title: '  Item Description  '),
                Text(widget.prodlist['productdesc']),
                const AccountInfoText(title: '  Similar Products  '),
                SizedBox(
                  height: 400.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productstream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Something went wrong !"));
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
                            return ProductsModelHomeW(
                                products: snapshot.data!.docs[index]);
                          },
                          staggeredTileBuilder: (index) =>
                              const StaggeredTile.fit(1));
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: SizedBox(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.store),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                ),
                MaterialYellowButton(label: "order now", onpressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
