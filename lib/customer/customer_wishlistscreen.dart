import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  final bool isback;
  const WishListScreen({super.key, this.isback = false});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: widget.isback ? const AppBarBackButton() : null,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: context.watch<Cart>().getItems.isEmpty
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Empty Cart"),
                                  content: const Text("Are you sure?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("No")),
                                    TextButton(
                                        onPressed: () {
                                          context.read<Cart>().clearCart();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes")),
                                  ],
                                );
                              });
                          // context.read<Cart>().clearCart();
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ),
                      ),
              )
            ],
            title: const AppbarTitle(
              subCategoryName: 'cart',
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItemW()
              : const EmptyCartW(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total: Rs. ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        context.watch<Cart>().totalPrice.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Material(
                    elevation: 8.0,
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20.0),
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text("CheckOut"),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

class EmptyCartW extends StatelessWidget {
  const EmptyCartW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your Cart is Empty ! ",
            style: TextStyle(fontFamily: 'Poppins', fontSize: 20.0),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Material(
            elevation: 8.0,
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(20.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.of(context).pop()
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerBottomNavigation(),
                        ),
                      );
              },
              child: const Text(
                "Add To Your Cart",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItemW extends StatelessWidget {
  const CartItemW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: SizedBox(
                  height: 120.0,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100.0,
                        width: 120.0,
                        child: Image.network(product.imageUrl.first),
                      ),
                      Flexible(
                        child: Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: "Poppins",
                                        fontSize: 16.0),
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
                                                  cart.removeItem(product);
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
                                          cart.getItems[index].qty.toString(),
                                          style: product.qty == product.qntty
                                              ? const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.red)
                                              : const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poppins'),
                                        ),
                                        IconButton(
                                          onPressed:
                                              product.qty == product.qntty
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
