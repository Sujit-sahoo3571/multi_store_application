import 'package:flutter/material.dart';
import 'package:multi_store_application/subcategoryscreen/subcategory.dart';

const barTextStyle =
    TextStyle(fontSize: 18.0, letterSpacing: 2, fontWeight: FontWeight.bold);

class CategoryItemHeading extends StatelessWidget {
  final String subHeadings;
  const CategoryItemHeading({
    Key? key,
    required this.subHeadings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        subHeadings,
        style: const TextStyle(fontSize: 24.0),
      ),
    );
  }
}

class CategorySlidebarText extends StatelessWidget {
  final String subcategoryName;
  const CategorySlidebarText({
    Key? key,
    required this.subcategoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        subcategoryName == 'men'
            ? const Text('')
            : const RotatedBox(
                quarterTurns: 1,
                child: Text(
                  '<<',
                  style: barTextStyle,
                ),
              ),
        RotatedBox(
          quarterTurns: 1,
          child: Text(
            subcategoryName.toUpperCase(),
            style: barTextStyle,
          ),
        ),
        subcategoryName == 'games'
            ? const Text('')
            : const RotatedBox(
                quarterTurns: 1,
                child: Text(
                  '>>',
                  style: barTextStyle,
                ),
              )
      ],
    );
  }
}

class CategoryImageView extends StatelessWidget {
  final String mainCategory;
  final String subCategory;
  final String image;
  final String label;
  const CategoryImageView({
    Key? key,
    required this.mainCategory,
    required this.subCategory,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SubCategory(
                mainCategoryName: mainCategory,
                subCategoryName: subCategory,
              );
            }));
          }),
          child: SizedBox(
            width: 80.0,
            height: 80.0,
            child: Image(
              image: AssetImage(image),
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
