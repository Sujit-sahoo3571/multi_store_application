import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/fake_search.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: const FakeSearch(),
          backgroundColor: Colors.white,
          elevation: 0.0,
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 7.0,
            isScrollable: true,
            tabs: [
              RepeatedTab(
                label: "Men",
              ),
              RepeatedTab(
                label: "Women",
              ),
              RepeatedTab(
                label: "Kids",
              ),
              RepeatedTab(
                label: "Gadgets",
              ),
              RepeatedTab(
                label: "Bags",
              ),
              RepeatedTab(
                label: "Watches",
              ),
              RepeatedTab(
                label: "Swords",
              ),
              RepeatedTab(
                label: "paintings",
              ),
              RepeatedTab(
                label: "Games",
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          Center(
            child: Text("Men"),
          ),
          Center(
            child: Text("Women"),
          ),
          Center(
            child: Text("Kids"),
          ),
          Center(
            child: Text("Gadgets"),
          ),
          Center(
            child: Text("Bags"),
          ),
          Center(
            child: Text("watches"),
          ),
          Center(
            child: Text("swords"),
          ),
          Center(
            child: Text("Paintings"),
          ),
          Center(
            child: Text("Games"),
          ),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
