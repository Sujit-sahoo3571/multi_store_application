import 'package:flutter/material.dart';
import 'package:multi_store_application/gallaries/bags_gallery.dart';
import 'package:multi_store_application/gallaries/gadgets_gallery.dart';
import 'package:multi_store_application/gallaries/games_gallary.dart';
import 'package:multi_store_application/gallaries/kids_gallery.dart';
import 'package:multi_store_application/gallaries/men_gallary.dart';
import 'package:multi_store_application/gallaries/painting_gallary.dart';
import 'package:multi_store_application/gallaries/swords_gallary.dart';
import 'package:multi_store_application/gallaries/watches_gallery.dart';
import 'package:multi_store_application/gallaries/women_gallery.dart';
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
        backgroundColor: const Color(0x99CFF5E7),
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
                label: "Paintings",
              ),
              RepeatedTab(
                label: "Games",
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          KidsGalleryScreen(),
          GadgetsGalleryScreen(),
          BagsGalleryScreen(),
          WatchesGalleryScreen(),
          SwordsGalleryScreen(),
          PaintingGalleryScreen(),
          GamesGalleryScreen(),
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
