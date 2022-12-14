import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_application/utility/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late double price;
  late int quantity;
  late String prodcutName;
  late String prodcutDescription;
  late String prodId;
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
                          initialValue: "0",
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
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
              ),
              child: FloatingActionButton(
                heroTag: 'images',
                backgroundColor: Colors.yellow,
                onPressed: imageFileList!.isEmpty
                    ? () {
                        pickimages();
                      }
                    : () {
                        setState(() {
                          imageFileList = [];
                        });
                      },
                child: imageFileList!.isEmpty
                    ? const Icon(
                        Icons.photo_library,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'upload',
              backgroundColor: Colors.yellow,
              onPressed: isLoading
                  ? null
                  : () {
                      uplaodProduct();
                    },
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
            )
          ],
        ),
      ),
    );
  }

  void uplaodProduct() async {
    // await uploaddata().whenComplete(() => uplaodImages());
    await uploaddata();
  }

  void uplaodImages() async {
    if (imageUrlList.isNotEmpty) {
      CollectionReference prodref =
          FirebaseFirestore.instance.collection('products');

      prodId = const Uuid().v4();

      await prodref.doc(prodId).set({
        'prodId': prodId,
        'maincategory': maincategoryvalue,
        'subcategory': subcategoryvalue,
        'price': price,
        'instock': quantity,
        'productname': prodcutName,
        'productdesc': prodcutDescription,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'productimages': imageUrlList,
        'discount': discount,
      }).whenComplete(() {
        _formKey.currentState!.reset();
        setState(() {
          isLoading = false;
          imageFileList = [];
          imageUrlList = [];
          subcatList = [];
          maincategoryvalue = 'maincategory';
        });
      });
    } else {
      print("no images available ");
    }
  }

//TODO

  Future<void> uploaddata() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (maincategoryvalue == 'maincategory' ||
        subcategoryvalue == 'subcategory') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content:
              Text("Please select the maincategory and subcategory first. "),
        ),
      );
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageFileList!.isEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Colors.greenAccent,
                content: Text("Pick images first"),
              ),
            );
        } else {
          setState(() {
            isLoading = true;
          });
          try {
            for (var image in imageFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/ ${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref
                    .getDownloadURL()
                    .then((value) => imageUrlList.add(value));
              });
            }
            uplaodImages();
            print(imageUrlList);
          } catch (e) {
            print(e);
          }
        }
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Colors.greenAccent,
              content: Text(
                "please fill all the fields",
              ),
            ),
          );
      }
    }
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
