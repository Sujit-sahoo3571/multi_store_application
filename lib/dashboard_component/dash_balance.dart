import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';
import 'package:multi_store_application/widgets/button_animlogo.dart';

class DashBalanceScreen extends StatelessWidget {
  const DashBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("sid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          double totalPrice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalPrice += item["orderqnty"] * item["orderprice"];
          }

          return Scaffold(
            appBar: AppBar(
              leading: const AppBarBackButton(),
              title: const AppbarTitle(subCategoryName: "Your Service Chart"),
              elevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatisticModel(
                    label: "Total balance ",
                    value: totalPrice,
                    decimal: 2,
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.red,
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text(
                        "Get My Money! ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class StatisticModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;
  const StatisticModel({
    Key? key,
    required this.label,
    required this.value,
    required this.decimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          height: 90.0,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0))),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedCounter(
                value: value,
                decimal: decimal,
              )),
        )
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic value;
  final int decimal;
  const AnimatedCounter(
      {super.key, required this.value, required this.decimal});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.value)
          .animate(_controller);
    });
    _controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toStringAsFixed(widget.decimal),
          textAlign: TextAlign.center,
          style: const TextStyle(
              letterSpacing: 4.0,
              fontSize: 22.0,
              fontFamily: "Poppins",
              color: Colors.pink,
              fontWeight: FontWeight.w600),
        );
      },
    );
  }
}
