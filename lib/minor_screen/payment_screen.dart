import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../provider/cart_provider.dart';
import '../widgets/button_animlogo.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const PaymentScreen(
      {super.key,
      required this.name,
      required this.phone,
      required this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: "Please wait...", progressBgColor: Colors.red);
  }

  late String orderId;

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 20.0;

    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Material(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0.0,
                  title: const Text("Payment "),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 64.0),
                  child: Column(
                    children: [
                      Container(
                        height: 120.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total ",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Text(
                                      "Rs. ${totalPaid.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18.0),
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total order ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                    Text(
                                      "Rs. ${totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Shipping cost ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                    Text(
                                      "Rs. 20.00",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ]),
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
                          child: Column(children: [
                            RadioListTile(
                              value: 1,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text("Cash on Delivery"),
                              subtitle: const Text("pay at home"),
                            ),
                            RadioListTile(
                              value: 2,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text("Debit / Credit Card "),
                              subtitle: Row(
                                children: const [
                                  Icon(
                                    Icons.payment,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Icon(
                                      FontAwesomeIcons.ccMastercard,
                                      color: Colors.blue,
                                      size: 30.0,
                                    ),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.ccVisa,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ),
                            RadioListTile(
                              value: 3,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text("Pay Pal"),
                              subtitle: Row(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.paypal,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Icon(
                                      FontAwesomeIcons.ccPaypal,
                                      color: Colors.blue,
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
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
                        label: "confirm  Rs. ${totalPaid.toStringAsFixed(2)} ",
                        width: 1.0,
                        onpressed: () {
                          if (selectedValue == 1) {
                            // print("cash on delivery");
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Pay at Home : Rs. ${totalPaid.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Color.fromARGB(
                                                    255, 31, 23, 23),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          ContainerYellowButton(
                                              label: "confirm",
                                              width: 0.9,
                                              onpressed: () async {
                                                showProgress();
                                                for (var item in context
                                                    .read<Cart>()
                                                    .getItems) {
                                                  CollectionReference orderref =
                                                      FirebaseFirestore.instance
                                                          .collection('orders');
                                                  orderId = Uuid().v4();

                                                  orderref.doc(orderId).set({
                                                    "cid": data['cid'],
                                                    "customername": widget.name,
                                                    "email": data['email'],
                                                    'address': widget.address,
                                                    "phone": widget.phone,
                                                    "profileimage":
                                                        data['profileimage'],
                                                    "sid": item.suppid,
                                                    "prodid": item.documentid,
                                                    "orderid": orderId,
                                                    "orderimage":
                                                        item.imageUrl.first,
                                                    "ordername": item.name,
                                                    "orderqnty": item.qty,
                                                    "orderprice":
                                                        item.qty * item.price,
                                                    "deliverystatus":
                                                        "preparing",
                                                    "deliverydate": "",
                                                    "orderdate": DateTime.now(),
                                                    "paymentstatus":
                                                        "cash on delivery",
                                                    "reviewrating": false,
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      DocumentReference
                                                          documentReference =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(item
                                                                  .documentid);

                                                      DocumentSnapshot
                                                          snapshot2 =
                                                          await transaction.get(
                                                              documentReference);
                                                      transaction.update(
                                                          documentReference, {
                                                        "instock": snapshot2[
                                                                "instock"] -
                                                            item.qty
                                                      });
                                                    });
                                                  });
                                                }
                                                context
                                                    .read<Cart>()
                                                    .clearCart();
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        '/customer_home')); // TODO Error
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                          if (selectedValue == 2) {
                            print("pay with visa ");
                          }
                          if (selectedValue == 3) {
                            print("pay with paypal");
                          }
                        }),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
