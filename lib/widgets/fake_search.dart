import 'package:flutter/material.dart';
import 'package:multi_store_application/minor_screen/appbar_search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AppBarSearch()));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.amber, width: 1.4),
            borderRadius: BorderRadius.circular(25.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 7.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "What are you looking for? ",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ],
            ),
            Container(
              height: 32.0,
              width: 75.0,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25.0)),
              child: const Center(
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
