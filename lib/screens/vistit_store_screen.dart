import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_application/widgets/home_products_widgets.dart';
import 'package:multi_store_application/screens/supplier/editstore/edit_store.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStoreScreen extends StatefulWidget {
  final String sid;

  const VisitStoreScreen({super.key, required this.sid});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  bool isFollow = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.sid)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.sid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: Colors.blueGrey.shade400,
            // store background
            appBar: AppBar(
              toolbarHeight: 100.0,
              flexibleSpace: data['coverimage'] == ""
                  ? Image.asset(
                      "assets/images/bgimage.jpg",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data["coverimage"],
                      fit: BoxFit.cover,
                    ),

              //storelogo and name in a row
              title: Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4.0, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11.0),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['storename'],
                        style: const TextStyle(
                            fontFamily: "Poppins", color: Colors.yellow),
                      ),
                    ),
                  ),
                  (data['sid'] == FirebaseAuth.instance.currentUser!.uid)
                      ?

                      // edit the store
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStore(
                                          data: data,
                                        )));
                          },
                          child: Row(
                            children: const [Text("Edit "), Icon(Icons.edit)],
                          ),
                        )
                      :
                      // follow the store
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFollow = !isFollow;
                            });
                          },
                          child: isFollow
                              ? const Text("Unfollow")
                              : const Text("Follow + ")),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: _productStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("something went wrong ");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "This category has no items for now.\nwe will update this soon!.",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ProductsModelHomeW(
                        products: snapshot.data!.docs[index],
                      );
                    },
                    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
