import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/minor_screen/payment_screen.dart';
import 'package:multi_store_application/provider/cart_provider.dart';
import 'package:multi_store_application/screens/add_address.dart';
import 'package:multi_store_application/screens/address_book.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  // CollectionReference customers =
  //     FirebaseFirestore.instance.collection('customers');

  String name= "";
  String phone="";
  String address=""; 

  Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection("customers")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("address")
      .where(
        "default",
        isEqualTo: true,
      )
      .limit(1)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something went wrong ");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // if (snapshot.data!.docs.isEmpty) {
          //   return const Center(
          //     child: Text(
          //       "please select an address.",
          //       textAlign: TextAlign.center,
          //       softWrap: true,
          //       style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 24.0,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   );
          // }

          return Material(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0.0,
                  title: const Text("Place Order"),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 64.0),
                  child: Column(
                    children: [
                      //change address
                      snapshot.data!.docs.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddAddress()));
                              },
                              child: Container(
                                height: 80.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Set Your Address",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                //change address.
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressBook()));
                              },
                              child: Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 16.0),
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var cus = snapshot.data!.docs[index];
                                         name = cus["name"];
                                         phone = cus["phone"];
                                         address = cus["address"] +
                                            " \n" +
                                            cus["city"] +
                                            " \n" +
                                            cus["state"] +
                                            " \n" +
                                            cus["country"];
                                        return ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name : ${cus["name"]}\nPhone:"
                                                "${cus["phone"]}\nAddress: ${cus["address"]}\n"
                                                "city: ${cus["city"]}\n"
                                                "state: ${cus["state"]}\n"
                                                "country: ${cus["country"]}",
                                                style: const TextStyle(
                                                    letterSpacing: 2.0,
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                                //change address.
                              ),
                            ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child:
                              Consumer<Cart>(builder: (context, cart, child) {
                            return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: (context, index) {
                                  final order = cart.getItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(width: 0.3)),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              bottomLeft: Radius.circular(15.0),
                                            ),
                                            child: SizedBox(
                                              height: 100.0,
                                              width: 100.0,
                                              child: Image.network(
                                                  order.imageUrl.first),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  order.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 16.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        order.price
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16.0),
                                                      ),
                                                      Text(
                                                        " X ${order.qty}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16.0),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContainerYellowButton(
                        label: "confirm  Rs. ${totalPrice.toStringAsFixed(2)} ",
                        width: 1.0,
                        onpressed: snapshot.data!.docs.isEmpty
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddAddress()));
                              }
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             PaymentScreen(
                                              name: name,
                                              phone: phone,
                                              address: address,
                                            ),),);
                              }),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
