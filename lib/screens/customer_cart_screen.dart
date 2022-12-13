import 'package:flutter/material.dart';
import 'package:multi_store_application/minor_screen/place_order.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/cart_model.dart';
import 'package:provider/provider.dart';

class CustomerCartScreen extends StatefulWidget {
  final bool isback;
  const CustomerCartScreen({super.key, this.isback = false});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
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
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 46.0),
                  child: CartItemW(),
                )
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
                        total.toStringAsFixed(2),
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
                      onPressed: total == 0.0
                          ? null
                          : () {
                              // print("place order ");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PlaceOrderScreen()));
                            },
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
                        child: CardListModel(
                            product: product, cart: context.read<Cart>()),
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
