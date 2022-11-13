import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/customer_main_screen.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerCartScreen extends StatelessWidget {
  final bool isback;
  const CustomerCartScreen({super.key, this.isback = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: isback ? const AppBarBackButton() : null,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
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
          body: Center(
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
                                builder: (context) =>
                                    CustomerBottomNavigation(),
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
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Total: Rs. ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '0.0',
                        style: TextStyle(
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
