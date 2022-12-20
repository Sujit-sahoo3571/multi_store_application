import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/add_address.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection("customers")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("address")
      .snapshots();

  Future dfAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("address")
          .doc(item.id);

      transaction.update(documentReference, {
        "default": false,
      });
    });
  }

  Future dfAddressTrue(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("address")
          .doc(customer["addressid"]);

      transaction.update(documentReference, {
        "default": true,
      });
    });
  }

  Future updateProfileAddress(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      transaction.update(documentReference, {
        "address": "${customer["address"]} - "
            "${customer["city"]}  - "
            "${customer["country"]} ",
        "phone": customer["phone"],
      });
    });
  }

  //show progress
  showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
        max: 100, msg: "please wait ... ", progressBgColor: Colors.red);
  }

  //close progress
  hideProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppbarTitle(subCategoryName: "Address Book"),
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: addressStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No address availible \n create a new one !",
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
                    final customer = snapshot.data!.docs[index];

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentReference docReference = FirebaseFirestore
                              .instance
                              .collection("customers")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("address")
                              .doc(customer["addressid"]);

                          transaction.delete(docReference);
                        });
                      },
                      child: InkWell(
                        onTap: () async {
                          showProgress();
                          //set all address false
                          for (var item in snapshot.data!.docs) {
                            await dfAddressFalse(item);
                          }

                          //set only current true
                          await dfAddressTrue(customer).whenComplete(
                              // add to current address.
                              () async => await updateProfileAddress(customer)
                                  .whenComplete(() => Navigator.pop(context)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: customer["default"]
                                ? Colors.lightBlueAccent
                                : Colors.white,
                            child: SizedBox(
                              child: ListTile(
                                trailing: customer["default"]
                                    ? const Icon(
                                        Icons.home,
                                        color: Colors.red,
                                        size: 35.0,
                                      )
                                    : const SizedBox(),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name : ${customer["name"]}\nPhone:"
                                      "${customer["phone"]}\nAddress: ${customer["address"]}\n"
                                      "city: ${customer["city"]}\n"
                                      "state: ${customer["state"]}\n"
                                      "country: ${customer["country"]}",
                                      style: const TextStyle(
                                          letterSpacing: 2.0,
                                          fontSize: 16.0,
                                          fontFamily: "Poppins"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
        floatingActionButton: MaterialGreenButton(
          label: "Add New Address",
          onpressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddAddress()));
          },
        ));
  }
}
