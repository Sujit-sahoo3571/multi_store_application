import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/cust_ord_wish/customer_order.dart';
import 'package:multi_store_application/cust_ord_wish/customer_wishlist.dart';
import 'package:multi_store_application/screens/address_book.dart';
import 'package:multi_store_application/screens/change_password.dart';
import 'package:multi_store_application/screens/customer_cart_screen.dart';
import 'package:multi_store_application/screens/welcome_screen.dart';
import 'package:multi_store_application/widgets/alertdialog.dart';
import 'package:multi_store_application/widgets/listtile_widget.dart';

// import 'add_address.dart';

const kdivider = Divider(
  height: 10.0,
  thickness: 2.0,
  color: Colors.grey,
);

class CustomerProfileScreen extends StatefulWidget {
  // final String documentId;
  const CustomerProfileScreen({
    super.key,
  });

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  String documentId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers'); //anonymus
  CollectionReference anonymus =
      FirebaseFirestore.instance.collection('anonymus');

  @override
  Widget build(BuildContext context) {
    final kscreen = MediaQuery.of(context).size;
    // checkId();

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymus.doc(documentId).get()
          : customers.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");

          return Scaffold(
              body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                backgroundColor: Colors.yellow,
                flexibleSpace: FlexibleSpaceBar(
                  // collapseMode: CollapseMode.pin,
                  title: const Text("Accounts"),
                  centerTitle: true,
                  background: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        data['profileimage'] == ''
                            ? const CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.red,
                                backgroundImage:
                                    AssetImage('assets/images/profile.png'))
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    NetworkImage(data['profileimage']),
                              ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          data['name'] == ''
                              ? 'GUEST'
                              : data['name'].toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              detailWidget(kscreen: kscreen, data: data),
            ],
          ));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget detailWidget(
      {required Size kscreen, required Map<String, dynamic> data}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 80.0,
              margin: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width * 0.86,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0)),
                    child: MaterialButton(
                      minWidth: kscreen.width * 0.25,
                      textColor: Colors.yellow,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomerCartScreen(
                                    isback: true,
                                  ))),
                      child: const Text("CART"),
                    ),
                  ),
                  Material(
                    color: Colors.yellow,
                    child: MaterialButton(
                      minWidth: kscreen.width * 0.25,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerOrdersScreen(),
                          ),
                        );
                      },
                      child: const Text("ORDERS"),
                    ),
                  ),
                  Material(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    child: MaterialButton(
                      minWidth: kscreen.width * 0.25,
                      textColor: Colors.yellow,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CustomerWishListScreen(),
                          ),
                        );
                      },
                      child: const Text("WISHLIST"),
                    ),
                  )
                ],
              ),
            ),
            //address
            const AccountInfoText(title: ' Account Profile '),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.grey, width: 2.0)),
              child: Column(children: [
                ListTile(
                  leading: const Icon(
                    Icons.email,
                  ),
                  title: const Text("Your Email Address: "),
                  subtitle: Text(data['email'] == ''
                      ? "example@email.com"
                      : data["email"]),
                ),
                kdivider,
                ListTile(
                  leading: const Icon(
                    Icons.phone,
                  ),
                  title: const Text("Your Phone No. : "),
                  subtitle: Text(data['phone'] == ''
                      ? 'eg: +91-9111111111'
                      : data['phone']),
                ),
                kdivider,
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                  ),
                  title: const Text("Your Address: "),
                  subtitle: Text(userAddress(data)),
                  onTap: FirebaseAuth.instance.currentUser!.isAnonymous
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddressBook())); // AddAddress()
                        },
                ),
              ]),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const AccountInfoText(title: ' Account Settings '),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.grey, width: 2.0)),
              child: Column(
                children: [
                  ListTileonTap(
                    icon: Icons.person,
                    lable: 'Change Profile',
                    onpressed: () {},
                  ),
                  kdivider,
                  ListTileonTap(
                    icon: Icons.lock,
                    lable: 'Change Password',
                    onpressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()));
                    },
                  ),
                  kdivider,
                  ListTileonTap(
                      icon: Icons.logout,
                      lable: 'Logout',
                      onpressed: () async {
                        await showalertDialogactionmsg(
                            context: context,
                            title: "Logout",
                            content: "Are you sure to logout? ",
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacementNamed(
                                      context, WelcomeScreen.welcomeRouteName);
                                },
                                child: const Text("Yes"),
                              ),
                            ]);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//function and methods
//userAddress.
  String userAddress(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return "example: Bhubaneswar, unit-4 ,India";
    } else if (!FirebaseAuth.instance.currentUser!.isAnonymous &&
        data['address'] == "") {
      return "set your Address ";
    }
    return data["address"];
  }
}
