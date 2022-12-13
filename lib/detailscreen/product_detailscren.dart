import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_application/Modelwidgets/home_products_widgets.dart';
import 'package:multi_store_application/minor_screen/full_view_image.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/provider/wishlist_product.dart';
import 'package:multi_store_application/screens/customer_cart_screen.dart';
import 'package:multi_store_application/screens/vistit_store_screen.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/listtile_widget.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';

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
    var onSale = widget.prodlist['discount'];
    var salePrice = onSale != 0
        ? ((1 - (onSale / 100)) * widget.prodlist["price"])
        : widget.prodlist["price"];

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
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FullScreenView(
                                imageList: productimage,
                              ))),
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
                    // change the discount price .
                    // Text(
                    //     " Rs. ${widget.prodlist['price'].toStringAsFixed(2)} "),
                    Row(
                      children: [
                        const Text("Rs.",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                        Text(
                          '${widget.prodlist['price'].toStringAsFixed(2)} ',
                          style: onSale != 0
                              ? const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600)
                              : const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                        ),
                        onSale != 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(" ${salePrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600)),
                              )
                            : const Text(""),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        //TODO

                        context.read<Wish>().getwishItems.firstWhereOrNull(
                                    (prod) =>
                                        prod.documentid ==
                                        widget.prodlist['prodId']) !=
                                null
                            ? context
                                .read<Wish>()
                                .removeThis(widget.prodlist['prodId'])
                            : context.read<Wish>().addWishItems(
                                  widget.prodlist['productname'],
                                  // widget.prodlist['price'],
                                  salePrice,
                                  1,
                                  widget.prodlist['instock'],
                                  widget.prodlist['productimages'],
                                  widget.prodlist['prodId'],
                                  widget.prodlist['sid'],
                                );
                      },
                      icon: context.watch<Wish>().getwishItems.firstWhereOrNull(
                                  (prod) =>
                                      prod.documentid ==
                                      widget.prodlist['prodId']) !=
                              null
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 35.0,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 35.0,
                            ),
                    ),
                  ],
                ),
                widget.prodlist['instock'] == 0
                    ? const Text(
                        "Out of Stock ",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      )
                    : Text(
                        ' ${widget.prodlist['instock']} No. of Pieces Available on Store. ',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400),
                      ),
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VisitStoreScreen(sid: widget.prodlist['sid']);
                    }));
                  },
                  icon: const Icon(Icons.store),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomerCartScreen(
                                  isback: true,
                                )));
                  },
                  icon: Badge(
                      showBadge:
                          context.read<Cart>().getItems.isEmpty ? false : true,
                      padding: const EdgeInsets.all(2.0),
                      badgeColor: Colors.yellow,
                      badgeContent: Text(
                        context.watch<Cart>().getItems.length.toString(),
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      child: const Icon(Icons.shopping_cart)),
                ),
                MaterialYellowButton(
                    label: context.read<Cart>().getItems.firstWhereOrNull(
                                (prod) =>
                                    prod.documentid ==
                                    widget.prodlist['prodId']) !=
                            null
                        ? "Product Added "
                        : "order now",
                    onpressed: () {
                      if (widget.prodlist['instock'] == 0) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("This item Out of Stock!"),
                          backgroundColor: Colors.red,
                        ));
                      } else if (context.read<Cart>().getItems.firstWhereOrNull(
                              (prod) =>
                                  prod.documentid ==
                                  widget.prodlist['prodId']) !=
                          null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("item already exist !"),
                          backgroundColor: Colors.yellow,
                        ));
                      } else {
                        context.read<Cart>().addItems(
                              widget.prodlist['productname'],
                              //
                              // onSale != 0 ? salePrice :
                              // widget.prodlist['price'],
                              salePrice,
                              1,
                              widget.prodlist['instock'],
                              widget.prodlist['productimages'],
                              widget.prodlist['prodId'],
                              widget.prodlist['sid'],
                            );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
