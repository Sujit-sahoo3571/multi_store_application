import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({super.key, this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? storeimage;
  XFile? coverImage;
  // dynamic errorvalue;
  late String storeName;
  late String phoneNumber;

//download store logo and cover
  late String storeLogo;
  late String storeCover;

  // processing
  bool isProcessing = false;

  final ImagePicker _picker = ImagePicker();

// PICK SOTRE LOGO
  pickStoreLogo() async {
    try {
      final pickstorelogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 95);
      setState(() {
        storeimage = pickstorelogo;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  pickCoverImage() async {
    try {
      final pickcoverimage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 95);
      setState(() {
        coverImage = pickcoverimage;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //upload images
  Future uploadStoreLogo() async {
    if (storeimage != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref("supplierimages/${widget.data["email"]}.jpg");

        await ref.putFile(File(storeimage!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data["storelogo"];
    }
  }

  //upload cover image
  Future uploadCoverImage() async {
    if (coverImage != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref("supplierimages/${widget.data["email"]}-cover.jpg");

        await ref2.putFile(File(coverImage!.path));

        storeCover = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeCover = widget.data["coverimage"];
    }
  }

  //upload edited store data
  Future editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("suppliers")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        "storename": storeName,
        "phone": phoneNumber,
        "storelogo": storeLogo,
        "coverimage": storeCover,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  //save changes
  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isProcessing = true;
      });

      await uploadStoreLogo().whenComplete(() async =>
          await uploadCoverImage().whenComplete(() => editStoreData()));
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text("please fill the valid fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const AppbarTitle(subCategoryName: "Edit Store "),
        leading: const AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        reverse: true,
        // form
        child: Form(
          key: formKey,
          child: Column(
            children: [
              //change store logo
              Column(
                children: [
                  const Text(
                    "Store Logo ",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.0,
                        color: Colors.blue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(widget.data["storelogo"]),
                      ),

                      Column(
                        children: [
                          MaterialYellowButton(
                              label: "change",
                              onpressed: () {
                                pickStoreLogo();
                              }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          storeimage == null
                              ? const SizedBox()
                              : MaterialYellowButton(
                                  label: "reset",
                                  onpressed: () {
                                    setState(() {
                                      storeimage = null;
                                    });
                                  }),
                        ],
                      ),

                      //change imaged
                      storeimage == null
                          ? const SizedBox()
                          : CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  FileImage(File(storeimage!.path)),
                            ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      thickness: 2.5,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              //change cover image
              Column(
                children: [
                  const Text(
                    "Cover Image  ",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.0,
                        color: Colors.blue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(widget.data["coverimage"]),
                      ),

                      Column(
                        children: [
                          MaterialYellowButton(
                              label: "change",
                              onpressed: () {
                                pickCoverImage();
                              }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          coverImage == null
                              ? const SizedBox()
                              : MaterialYellowButton(
                                  label: "reset",
                                  onpressed: () {
                                    setState(() {
                                      coverImage = null;
                                    });
                                  }),
                        ],
                      ),

                      //change imaged
                      coverImage == null
                          ? const SizedBox()
                          : CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  FileImage(File(coverImage!.path)),
                            ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      thickness: 2.5,
                      color: Colors.green,
                    ),
                  )
                ],
              ),

              //store name
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a store name ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    storeName = value!;
                  },
                  initialValue: widget.data["storename"],
                  decoration: textFormDecoration.copyWith(
                      labelText: "storename", hintText: "AA Store"),
                ),
              ),
              //phone
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone Number";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value!;
                  },
                  initialValue: widget.data["phone"],
                  decoration: textFormDecoration.copyWith(
                      labelText: "Phone", hintText: "+9111111111"),
                ),
              ),
              //submit and cancel button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialYellowButton(
                        label: "cancel",
                        onpressed: () {
                          Navigator.pop(context);
                        }),
                    const SizedBox(
                      width: 20.0,
                    ),
                    isProcessing
                        ? MaterialYellowButton(
                            label: "loading ...",
                            onpressed: () {
                              null;
                            })
                        : MaterialYellowButton(
                            label: "save changes",
                            onpressed: () {
                              saveChanges();
                            }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
    labelText: "text",
    hintText: "hinttext",
    labelStyle: const TextStyle(color: Colors.purple),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.yellow, width: 1.0),
        borderRadius: BorderRadius.circular(25.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        borderRadius: BorderRadius.circular(25.0)));
