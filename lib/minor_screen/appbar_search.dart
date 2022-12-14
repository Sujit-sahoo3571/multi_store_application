import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/detailscreen/product_detailscren.dart';

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({super.key});

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  final TextEditingController _controller = TextEditingController();


  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  String searchInput = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SizedBox(
          height: 36.0,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                searchInput = _controller.text;
              });
              // print("conteroller : ${_controller.text} ");
            },
            maxLines: 1,
            style: const TextStyle(
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    searchInput = "";
                    _controller.clear();
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(width: 2.0, color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.only(bottom: 2.0),
            ),
          ),
        ),
      ),
      body: searchInput == ""
          ? Center(
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(24.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search_rounded,
                      size: 30.0,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "search anything you love...",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Poppins",
                          color: Colors.grey),
                    )
                  ],
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

// final result for input
                final resultSearch = snapshot.data!.docs.where((e) =>
                    e["productname".toLowerCase()]
                        .contains(searchInput.toLowerCase()));

                return ListView(
                    children:
                        resultSearch.map((e) => SearchModel(e: e)).toList());
              }),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(prodlist: e))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        20.0,
                      ),
                      bottomLeft: Radius.circular(20.0)),
                  child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Image.network(
                        e["productimages"][0],
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                      e["productname"],
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      e["productdesc"],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
