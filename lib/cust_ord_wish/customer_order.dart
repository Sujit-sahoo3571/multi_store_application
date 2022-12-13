import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/customer_order_model.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppbarTitle(subCategoryName: "Orders"),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("cid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("something went wrong ");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "You Have NO Active Order Yet.",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var order = snapshot.data!.docs[index];
                  return CustomerOrderModel(order: order);
                });
          }),
    );
  }
}
