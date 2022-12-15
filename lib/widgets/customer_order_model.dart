import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';

class CustomerOrderModel extends StatefulWidget {
  const CustomerOrderModel({
    Key? key,
    required this.order,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> order;

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  String comment = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.yellow),
            borderRadius: BorderRadius.circular(15.0)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(
              maxHeight: 100.0,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15.0),
                  constraints:
                      const BoxConstraints(maxHeight: 80.0, maxWidth: 80.0),
                  child: Image.network(widget.order["orderimage"]),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.order["ordername"],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Rs. ${widget.order["orderprice"]}"),
                            Text(" X ${widget.order["orderqnty"]}")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "See more ...",
                style: TextStyle(color: Colors.cyan),
              ),
              Text(
                " ${widget.order["deliverystatus"]}",
                style: const TextStyle(color: Colors.cyan),
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: widget.order["deliverystatus"] == "delivered"
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name : ${widget.order['customername']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "Phone : ${widget.order['phone']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "email : ${widget.order['email']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "address : ${widget.order['address']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "payment method : ${widget.order['paymentstatus']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Row(
                    children: [
                      const Text(
                        "delivery status :  ",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        "${widget.order['deliverystatus']} ",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  if (widget.order['deliverystatus'] != 'preparing')
                    Text(
                      "estimated delivery date : "
                      " ${DateFormat("dd-MM-yyyy").format(widget.order['deliverydate'].toDate())} ",
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  if (widget.order['deliverystatus'] == 'delivered')
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Material(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 100.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          //rating bar
                                          RatingBar.builder(
                                              initialRating: 1,
                                              minRating: 1,
                                              allowHalfRating: true,
                                              itemBuilder: (context, index) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              onRatingUpdate: (value) {
                                                rate = value;
                                              }),

                                          //review comments
                                          TextFormField(
                                            initialValue: "Good",
                                            decoration: InputDecoration(
                                                hintText: "Enter your review",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .yellow,
                                                                width: 2))),
                                            onChanged: (value) {
                                              comment = value;
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, right: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                //cancel button
                                                MaterialYellowButton(
                                                    label: "Cancel",
                                                    onpressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                //ok button
                                                MaterialYellowButton(
                                                    label: "OK",
                                                    onpressed: () async {
                                                      print("y");

                                                      CollectionReference
                                                          collref =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "products")
                                                              .doc(widget.order[
                                                                  "prodid"])
                                                              .collection(
                                                                  "reviews");
                                                      print("x");

                                                      await collref
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        "name": widget.order[
                                                            "customername"],
                                                        "email": widget
                                                            .order["email"],
                                                        "rate": rate,
                                                        "comment": comment,
                                                        "profileimage":
                                                            widget.order[
                                                                "profileimage"]
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
                                                                      "orders")
                                                                  .doc(widget
                                                                          .order[
                                                                      "orderid"]);

                                                          transaction.update(
                                                              documentReference,
                                                              {
                                                                "reviewrating":
                                                                    true
                                                              });
                                                        });
                                                      });
                                                      Future.delayed(
                                                              const Duration(
                                                                  microseconds:
                                                                      100))
                                                          .whenComplete(() =>
                                                              Navigator.pop(
                                                                  context));
                                                    }),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: const Text("Write a review")),
// check review done or not .
                  widget.order['deliverystatus'] == 'delivered' &&
                          widget.order['reviewrating'] == true
                      ? const Text("Review submited but you can edit now")
                      : const Text("no review yet. ")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
