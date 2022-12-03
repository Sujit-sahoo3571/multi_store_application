import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/provider/product_class.dart';


class CardListModel extends StatelessWidget {
  const CardListModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                fontSize: 16.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs. ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.red, fontFamily: "Poppins", fontSize: 16.0),
              ),
              Container(
                height: 35.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    product.qty == 1
                        ? IconButton(
                            onPressed: () {
                              // cart.removeItem(product);

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete"),
                                  content: const Text("Sure to delete this? "),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          cart.removeItem(product);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"))
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              size: 16.0,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              cart.reduceByOne(product);
                            },
                            icon: const Icon(
                              FontAwesomeIcons.minus,
                              size: 16.0,
                            ),
                          ),
                    Text(
                      // "123",
                      product.qty.toString(),
                      style: product.qty == product.qntty
                          ? const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Poppins',
                              color: Colors.red)
                          : const TextStyle(
                              fontSize: 20.0, fontFamily: 'Poppins'),
                    ),
                    IconButton(
                      onPressed: product.qty == product.qntty
                          ? null
                          : () {
                              cart.increment(product);
                            },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
