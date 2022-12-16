import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/detailscreen/product_detailscren.dart';
import 'package:multi_store_application/minor_screen/edit_product.dart';
import 'package:multi_store_application/provider/wishlist_product.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductsModelHomeW extends StatefulWidget {
  final dynamic products;
  const ProductsModelHomeW({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductsModelHomeW> createState() => _ProductsModelHomeWState();
}

class _ProductsModelHomeWState extends State<ProductsModelHomeW> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products["discount"];
    var salePrice = onSale != 0
        ? ((1 - (widget.products["discount"] / 100)) * widget.products["price"])
        : widget.products["price"];

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            prodlist: widget.products,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 250.0,
                        minHeight: 100.0,
                      ),
                      child: Image(
                          image: NetworkImage(
                              widget.products['productimages'][0])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.products['productname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // REMOVED ROW
                              child: Text(
                                "Rs. "
                                '${widget.products['price'].toStringAsFixed(2)} ',
                                style: onSale != 0
                                    ? const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600)
                                    : const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                            (widget.products["sid"] ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? IconButton(
                                    onPressed: () {
                                      // edit the product .
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProduct(
                                                    items: widget.products,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      context
                                                  .read<Wish>()
                                                  .getwishItems
                                                  .firstWhereOrNull((prod) =>
                                                      prod.documentid ==
                                                      widget.products[
                                                          'prodId']) !=
                                              null
                                          ? context.read<Wish>().removeThis(
                                              widget.products['prodId'])
                                          : context.read<Wish>().addWishItems(
                                                widget.products['productname'],

                                                // widget.products['price'],
                                                salePrice,

                                                1,
                                                widget.products['instock'],
                                                widget
                                                    .products['productimages'],
                                                widget.products['prodId'],
                                                widget.products['sid'],
                                              );
                                    },
                                    icon: context
                                                .watch<Wish>()
                                                .getwishItems
                                                .firstWhereOrNull((prod) =>
                                                    prod.documentid ==
                                                    widget
                                                        .products['prodId']) !=
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
                        Row(
                          children: [
                            onSale != 0
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "@New Price \nRs. ${salePrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600)),
                                  )
                                : const Text("")
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 30.0,
                    left: 0.0,
                    child: Container(
                      height: 25.0,
                      width: 80.0,
                      decoration: const BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15.0))),
                      child: Center(
                          child: Text(
                              'Save ${widget.products["discount"].toString()} %')),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
