
import 'package:flutter/material.dart';
import 'package:multi_store_application/provider/wishlist_product.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/wishlist_model.dart';
import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';

class CustomerWishListScreen extends StatefulWidget {
  const CustomerWishListScreen({
    super.key,
  });

  @override
  State<CustomerWishListScreen> createState() => _CustomerWishListScreenState();
}

class _CustomerWishListScreenState extends State<CustomerWishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBarBackButton(),
            elevation: 0.0,
            // actions: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: context.watch<Cart>().getItems.isEmpty
            //       ? const SizedBox()
            //       : IconButton(
            //           onPressed: () {
            //             showDialog(
            //                 context: context,
            //                 builder: (context) {
            //                   return AlertDialog(
            //                     title: const Text("Empty Cart"),
            //                     content: const Text("Are you sure?"),
            //                     actions: [
            //                       TextButton(
            //                           onPressed: () =>
            //                               Navigator.of(context).pop(),
            //                           child: const Text("No")),
            //                       TextButton(
            //                           onPressed: () {
            //                             context.read<Cart>().clearCart();
            //                             Navigator.of(context).pop();
            //                           },
            //                           child: const Text("Yes")),
            //                     ],
            //                   );
            //                 });
            //             // context.read<Cart>().clearCart();
            //           },
            //           icon: const Icon(
            //             Icons.delete_forever,
            //             color: Colors.black,
            //           ),
            //         ),
            // )
            // ],
            title: const AppbarTitle(
              subCategoryName: 'WishList',
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: context.watch<Wish>().getwishItems.isNotEmpty
              ? const WishItemsW()
              : const EmptyWishList(),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Your wishlist is Empty ! ",
            style: TextStyle(fontFamily: 'Poppins', fontSize: 20.0),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

class WishItemsW extends StatelessWidget {
  const WishItemsW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(builder: (context, wish, child) {
      return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            final product = wish.getwishItems[index];
            return wishListModel(product: product);
          });
    });
  }
}

