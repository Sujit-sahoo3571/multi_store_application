import 'package:flutter/material.dart';
import 'package:multi_store_application/categoryscreens/bags_category.dart';
import 'package:multi_store_application/categoryscreens/gadgets_category.dart';
import 'package:multi_store_application/categoryscreens/games_category.dart';
import 'package:multi_store_application/categoryscreens/kids_category.dart';
import 'package:multi_store_application/categoryscreens/men_category.dart';
import 'package:multi_store_application/categoryscreens/painting_category.dart';
import 'package:multi_store_application/categoryscreens/swords_category.dart';
import 'package:multi_store_application/categoryscreens/watches_category.dart';
import 'package:multi_store_application/categoryscreens/women_category.dart';
import 'package:multi_store_application/widgets/fake_search.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    for (var element in _categoryItems) {
      element.isSelected = false;
    }
    setState(() {
      _categoryItems[0].isSelected = true;
    });
  }

  final PageController _pageController = PageController();
  final List<ItemData> _categoryItems = [
    ItemData(label: "Men"),
    ItemData(label: "Women"),
    ItemData(label: "Kids"),
    ItemData(label: "Gadgets"),
    ItemData(label: "Paintings"),
    ItemData(label: "Bags"),
    ItemData(label: "Watches"),
    ItemData(label: "Swords"),
    ItemData(label: "Games"),
  ];

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const FakeSearch(),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          sideView(screensize),
          categoryView(screensize),
        ],
      ),
    );
  }

  Widget sideView(Size size) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: SizedBox(
        height: size.height * 0.8,
        width: size.width * 0.25,
        child: ListView.builder(
            itemCount: _categoryItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceInOut);
                },
                child: Container(
                  color: _categoryItems[index].isSelected
                      ? Colors.white
                      : Colors.grey.shade300,
                  height: 100,
                  child: Center(
                    child: Text(_categoryItems[index].label),
                  ),
                ),
              );
            }),
      ),
    );
  }

// "Men", "Women", "Kids" , "Gadgets" , "Paintings" , "Bags" , "Watches", "Swords", "Games"
  Widget categoryView(Size size) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        height: size.height * 0.8,
        width: size.width * 0.75,
        color: Colors.white,
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            for (var element in _categoryItems) {
              element.isSelected = false;
            }
            setState(() {
              _categoryItems[value].isSelected = true;
            });
          },
          scrollDirection: Axis.vertical,
          children: const [
            MenCategory(),
            WomenCategory(),
            KidsCategory(),
            GadgetsCategory(),
            PaintingCategory(),
            BagCategory(),
            WatchesCategory(),
            SwordCategory(),
            GamesCategory(),
          ],
        ),
      ),
    );
  }
}

class ItemData {
  final String label;
  bool isSelected;
  ItemData({required this.label, this.isSelected = false});
}
