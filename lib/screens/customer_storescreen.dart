import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/screens/vistit_store_screen.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerStoreScreen extends StatelessWidget {
  const CustomerStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const AppbarTitle(subCategoryName: 'Store'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("suppliers").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitStoreScreen(
                                      sid: snapshot.data!.docs[index]['sid'],
                                    )));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120.0,
                            height: 120.0,
                            child: Image(
                              image: NetworkImage(
                                  snapshot.data!.docs[index]['storelogo']),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data!.docs[index]["storename"],
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return const Center(
              child: Text("NO Stores Available "),
            );
          },
        ));
  }
}
