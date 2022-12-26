import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/hot_deals.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';
import 'package:multi_store_application/widgets/subcategory.dart';

import '../gallaries/women_gallery.dart';
import 'customer_main_screen.dart';

enum Offer { watches, shoes, sales }

class OnBoardingScreen extends StatefulWidget {
  static const String onboarding = "/on_boarding_screen";
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  Timer? countdownTimeer;
  int sec = 3;
  List<int> discountList = [];
  int? maxDiscount;
  int selectedIndex = 0;
  String offerName = "offers";
  String assetName = "shoes";
  Offer offer = Offer.watches;
  late AnimationController _animationController;
  late Animation<Color?> _tweenAnimationColor;

  //
  void startTimer() {
    countdownTimeer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        sec--;
      });

      if (sec == 0) {
        stopTimer();
        navigate();
      }
    });
  }

  void stopTimer() {
    countdownTimeer!.cancel();
  }

  @override
  void initState() {
    getDiscount();
    selectRandomOffer();
    startTimer();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _tweenAnimationColor = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();

    super.dispose();
  }

  void getDiscount() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        discountList.add(doc["discount"]);
      }
    }).whenComplete(() => setState(() {
              maxDiscount = discountList.reduce((max));
            }));
  }

  void selectRandomOffer() {
    for (var i = 0; i < Offer.values.length; i++) {
      var random = Random();
      setState(() {
        selectedIndex = random.nextInt(3);
        // offerName = Offer.values[selectedIndex].toString();
        offer = Offer.values[selectedIndex];
      });
    }
    offerName = Offer.values[selectedIndex].toString();
    assetName = offerName.replaceAll("Offer.", "");
  }

  void navigateToOffer() {
    switch (offer) {
      case Offer.sales:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HotDeals(
                      fromONBoard: true,
                      maxdiscount: maxDiscount,
                    )));

        break;

      // default:
      case Offer.watches:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SubCategory(
                      mainCategoryName: "Watches",
                      subCategoryName: "G-shock",
                      fromONboarding: true,
                    )));
        break;
      case Offer.shoes:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const WomenGalleryScreen(
                      fromONBording: true,
                    )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              stopTimer();
              navigateToOffer();
            },
            child: Image.asset(
              // "assets/images/SALE1.jpg",
              "assets/images/$assetName.png",

              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 60.0,
              right: 30.0,
              child: MaterialGreenButton(
                  label: sec > 1 ? "skip | $sec " : "skip",
                  onpressed: () {
                    stopTimer();
                    navigate();
                  })),
          Positioned(
              bottom: 60.0,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      height: 70.0,
                      width: MediaQuery.of(context).size.width,
                      color: _tweenAnimationColor.value,
                      child: child,
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Shop Now ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          maxDiscount != null
              ? Positioned(
                  right: 60.0,
                  top: 140.0,
                  child: AnimatedOpacity(
                    opacity: _animationController.value,
                    duration: const Duration(microseconds: 100),
                    child: Text(
                      "$maxDiscount %",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 50.0),
                    ),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }

  void navigate() {
    Navigator.pushReplacementNamed(
        context, CustomerBottomNavigation.customerHomeRouteName);
  }
}
