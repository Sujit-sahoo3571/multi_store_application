import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_application/utility/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({super.key, required this.items});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double price = 0.0;
  int quantity = 0;
  String prodcutName = "";
  String prodcutDescription = "";
  //  String prodId;
  int? discount = 0;

  String? maincategoryvalue = 'maincategory';
  String? subcategoryvalue = 'subcategory';
  List<String> subcatList = [];

  List<XFile>? imageFileList = [];
  List<String> imageUrlList = [];

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  void pickimages() async {
    try {
      final List<XFile> productImages = await _picker.pickMultiImage(
          maxHeight: 300.0, maxWidth: 300.0, imageQuality: 90);
      setState(() {
        imageFileList = productImages;
      });
    } catch (e) {
      print('error code :custom  $e');
    }
  }

  Widget previewImage() {
    if (imageFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imageFileList![index].path));
          });
    } else {
      return const Center(
        child: Text(
          "You have not \n \n picked your image yet ? ",
          softWrap: true,
          textAlign: TextAlign.center,
          // style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget previewCurrentImage() {
    List<dynamic> itemImages = widget.items["productimages"];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index]);
        });
  }

  void selectMainCategory(String? value) {
    switch (value) {
      case 'men':
        subcatList = men;
        break;
      case 'women':
        subcatList = women;
        break;
      case 'kids':
        subcatList = kids;
        break;
      case 'swords':
        subcatList = swords;
        break;
      case 'games':
        subcatList = games;
        break;
      case 'gadgets':
        subcatList = gadgets;
        break;
      case 'bags':
        subcatList = bags;
        break;
      case 'watches':
        subcatList = watches;
        break;
      case 'paintings':
        subcatList = paintings;
        break;

      default:
        subcatList = [];
    }
    setState(() {
      maincategoryvalue = value;
      subcategoryvalue = 'subcategory';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // see the current images and category
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: screensize.width * 0.5,
                          width: screensize.width * 0.5,
                          color: const Color(0xffFFE9B1), // FFE9B1
                          child: previewCurrentImage(),
                        ),
                        SizedBox(
                          height: screensize.width * 0.5,
                          width: screensize.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // show the category
                              ListTile(
                                title: const Text("Main Category "),
                                subtitle: Text(
                                  widget.items["maincategory"],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
                                ),
                              ),
                              //sub category
                              ListTile(
                                title: const Text("Sub Category "),
                                subtitle: Text(
                                  widget.items["subcategory"],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    ExpandablePanel(
                      header: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Edit Product ",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.blue),
                        ),
                      ),
                      collapsed: const SizedBox(),
                      expanded: changeImage(screensize),
                      theme: const ExpandableThemeData(
                          iconColor: Colors.blue, iconSize: 35.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                  child: Divider(
                    color: Colors.yellow,
                    thickness: 2.0,
                  ),
                ),

// price and discount
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screensize.width * 0.38,
                        child: TextFormField(
                          initialValue:
                              widget.items["price"].toStringAsFixed(2),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter price ';
                            } else if (!value.isValidPrice()) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: textFieldDecoration.copyWith(
                            hintText: "Enter Price : ? ",
                            labelText: "Price",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screensize.width * 0.38,
                        child: TextFormField(
                          initialValue: widget.items["discount"].toString(),
                          autocorrect: false,
                          //TODO Error
                          maxLength: 2,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            } else if (!value.isValidDiscount()) {
                              return 'Invalid Discount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            discount = int.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          decoration: textFieldDecoration.copyWith(
                            hintText: "discount %",
                            labelText: "discount",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screensize.width * 0.45,
                    child: TextFormField(
                      initialValue: widget.items["instock"].toString(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter quantity ';
                        } else if (!value.isValidQuantity()) {
                          return 'Invalid quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        quantity = int.parse(value!);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Enter Quantity: ? ",
                        labelText: "Quantity",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screensize.width,
                    child: TextFormField(
                      initialValue: widget.items["productname"],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product name  ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        prodcutName = value!;
                      },
                      maxLength: 100,
                      maxLines: 3,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Enter product name ? ",
                        labelText: "product name",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screensize.width,
                    child: TextFormField(
                      initialValue: widget.items["productdesc"],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product description ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        prodcutDescription = value!;
                      },
                      maxLength: 800,
                      maxLines: 5,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Enter product description  ? ",
                        labelText: "product description",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialYellowButton(
                          label: "cancel",
                          onpressed: () {
                            Navigator.pop(context);
                          }),
                      MaterialYellowButton(
                          label: "save changes",
                          onpressed: () {
                            saveChanges();
                          }),
                      IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Are you sure to Delete this product ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              // await uploadImages()
                                              //     .whenComplete(() => editProductData())
                                              //     .whenComplete(() => Navigator.pop(context));
                                              await FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                    DocumentReference
                                                        documentReference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(widget.items[
                                                                "prodId"]);
                                                    transaction.delete(
                                                        documentReference);
                                                  })
                                                  .whenComplete(() =>
                                                      Navigator.pop(context))
                                                  .whenComplete(() =>
                                                      Navigator.pop(context));
                                            },
                                            child: const Text("Yes")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 40.0,
                            color: Colors.red,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // uplaod images
  Future uploadImages() async {
    // else {
    if (imageFileList!.isNotEmpty) {
      try {
        for (var image in imageFileList!) {
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('products/ ${path.basename(image.path)}');

          await ref.putFile(File(image.path)).whenComplete(() async {
            await ref.getDownloadURL().then((value) => imageUrlList.add(value));
          });
        }
        print(imageUrlList);
      } catch (e) {
        print(e);
      }
    } else {
      imageUrlList = (widget.items["productimages"] as List)
          .map((e) => e as String)
          .toList();

      print("imageurl : $imageUrlList");
    }
  }
  // }

  //check textfield data
  bool checkFormFieldData() {
    if (maincategoryvalue == 'maincategory') {
      maincategoryvalue = widget.items["maincategory"];
    }
    if (subcategoryvalue == 'subcategory') {
      subcategoryvalue = widget.items["subcategory"];
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text("Please fill the detail form correctly. "),
        ),
      );
      return false;
    }
  }

  //edit product data
  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("products")
          .doc(widget.items["prodId"]);

      transaction.update(documentReference, {
        'maincategory': maincategoryvalue,
        'subcategory': subcategoryvalue,
        'price': price,
        'instock': quantity,
        'productname': prodcutName,
        'productdesc': prodcutDescription,
        'productimages': imageUrlList,
        'discount': discount,
      });
    }).whenComplete(() {
      imageUrlList = [];
      Navigator.pop(context);
    });
  }

  // save changes upload to firebase
  saveChanges() async {
    if (checkFormFieldData()) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Save changes!"),
                content: const Text("Are you sure to change the product ?"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await uploadImages()
                            .whenComplete(() => editProductData())
                            .whenComplete(() => Navigator.pop(context));
                      },
                      child: const Text("Yes")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No")),
                ],
              ));
    }
  }

  // widget return change image
  Widget changeImage(Size screensize) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: screensize.width * 0.5,
              width: screensize.width * 0.5,
              color: const Color(0xffFFE9B1), // FFE9B1
              child: previewImage(),
            ),
            SizedBox(
              height: screensize.width * 0.5,
              width: screensize.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: Text(
                      '* select main category',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  DropdownButton(
                      dropdownColor: Colors.yellow,
                      menuMaxHeight: 400.0,
                      iconEnabledColor: Colors.red,
                      value: maincategoryvalue,
                      items: maincategory
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        selectMainCategory(value);
                      }),
                  const Text(
                    '* select sub category',
                    style: TextStyle(color: Colors.red),
                  ),
                  DropdownButton(
                      disabledHint: const Text('select subcategory'),
                      dropdownColor: Colors.yellow,
                      menuMaxHeight: 400.0,
                      iconEnabledColor: Colors.red,
                      value: subcategoryvalue,
                      items: subcatList //TODO
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          subcategoryvalue = value;
                        });
                      }),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: imageFileList!.isEmpty
              ? MaterialYellowButton(
                  label: "Change Images",
                  onpressed: () {
                    pickimages();
                  })
              : MaterialYellowButton(
                  label: "Remove Images ",
                  onpressed: () {
                    setState(() {
                      imageFileList = [];
                    });
                  }),
        )
      ],
    );
  }
}

var textFieldDecoration = InputDecoration(
  labelText: "Price",
  hintText: "Enter price : ",
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(
      color: Colors.yellow,
      width: 2.0,
    ),
  ),
);

extension QuantityValidate on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

// r'^(([0][\.]{1}[0-9]{1,2})||([1-9][0-9]*)||([1-9][0-9]*[\.]{1}[0-9]{1,2}))$'
extension PriceValidate on String {
  bool isValidPrice() {
    return RegExp(r'^(([1-9][0-9]*)||([1-9][0-9]*[\.]{1}[0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidate on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
