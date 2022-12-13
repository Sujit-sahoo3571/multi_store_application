import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  const SupplierOrderModel({
    Key? key,
    required this.order,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> order;

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
                  child: Image.network(order["orderimage"]),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        order["ordername"],
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
                            Text("Rs. ${order["orderprice"]}"),
                            Text(" X ${order["orderqnty"]}")
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
                " ${order["deliverystatus"]}",
                style: const TextStyle(color: Colors.cyan),
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name : ${order['customername']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "Phone : ${order['phone']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "email : ${order['email']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "address : ${order['address']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    "payment method : ${order['paymentstatus']} ",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
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
                        "${order['deliverystatus']} ",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Order date :  ",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        "${DateFormat("dd-MM-yyyy").format(order['orderdate'].toDate())} ",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  order['deliverystatus'] == "delivered"
                      ? const Text(
                          "Order has been already delivered .",
                          style: TextStyle(color: Colors.red),
                        )
                      : Row(
                          children: [
                            const Text(
                              "Change Delivery status to :  ",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            order['deliverystatus'] == "preparing"
                                ? TextButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(const Duration(days: 365)),
                                        onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(order["orderid"])
                                              .update({
                                            "deliverystatus": "shipping",
                                            "deliverydate": date,
                                          });
                                        },
                                      );
                                    },
                                    child: const Text("Shipping ?"))
                                : TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("orders")
                                          .doc(order["orderid"])
                                          .update({
                                        "deliverystatus": "delivered",
                                      });
                                    },
                                    child: const Text("Delivered")),
                          ],
                        ),
                  order["deliverystatus"] == "shipping"
                      ? Text(
                          "Estimated Delivery date: ${DateFormat("dd-MM-yyyy").format(order['deliverydate'].toDate())}",
                          style: const TextStyle(color: Colors.blue),
                        )
                      : const Text(""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
