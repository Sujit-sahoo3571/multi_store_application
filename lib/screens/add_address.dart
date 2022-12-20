import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = "";
  String phone = "";
  String address = "";
  String stateValue = "Choose State";
  String countryValue = "Choose Country";
  String cityValue = "Choose City";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppbarTitle(subCategoryName: "Add Address"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //name
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onSaved: (value) {
                          name = value!;
                          print("name : $name");
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty ||
                              value.trim().length <= 2) {
                            return "Please enter a valid name";
                          }
                          return null;
                        },
                        style: const TextStyle(letterSpacing: 1.5),
                        decoration: decorationBorder.copyWith(
                          label: const Text("Name"),
                          hintText: "Enter Your Name",
                        ),
                      ),
                      //phone
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          phone = value!;
                          print("phone : $phone");
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please enter a valid Phone";
                          }
                          return null;
                        },
                        style: const TextStyle(letterSpacing: 1.5),
                        decoration: decorationBorder.copyWith(
                          label: const Text("Phone"),
                          hintText: "+911111111",
                        ),
                      ),
                    ),
                    // address.
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          address = value!;
                          print("address : $address ");
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty ||
                              value.trim().length <= 2) {
                            return "Please enter a valid Address";
                          }
                          return null;
                        },
                        style: const TextStyle(letterSpacing: 1.5),
                        decoration: decorationBorder.copyWith(
                          label: const Text("Address"),
                          hintText: "Enter Your Address",
                        ),
                      ),
                    ),
                    //select state
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialYellowButton(
                label: "Save New Address",
                onpressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (stateValue != "Choose State" &&
                        countryValue != "Choose Country" &&
                        cityValue != "Choose City") {
                      print(" $stateValue, $countryValue, $cityValue ");
                      formKey.currentState!.save();
                      //store in firebase
                      CollectionReference addressref = FirebaseFirestore
                          .instance
                          .collection("customers")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("address");
                      var addressid = const Uuid().v4();
                      await addressref.doc(addressid).set({
                        "addressid": addressid,
                        "name": name,
                        "phone": phone,
                        "address": address,
                        "country": countryValue,
                        "state": stateValue,
                        "city": cityValue,
                        "default": true, // false ;
                      }).whenComplete(() => Navigator.pop(context));

                      //end
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            backgroundColor: Colors.blue,
                            content: Text("please Select all the fields")));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("please fill all the fields")));
                  }
                }),
          ],
        ),
      ),
    );
  }
}

final decorationBorder = InputDecoration(
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide()),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(
      color: Colors.purple,
    ),
  ),
);
