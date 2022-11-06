import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final kscreen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const AppbarTitle(subCategoryName: 'Accounts')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  height: 140.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage:
                              AssetImage('assets/images/image1.jpg'),
                        ),
                      ),
                      Text(
                        "Hi, I am Ella ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 80.0,
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
                        onPressed: () {},
                        child: const Text("CART"),
                      ),
                    ),
                    Material(
                      color: Colors.yellow,
                      child: MaterialButton(
                        minWidth: kscreen.width * 0.25,
                        textColor: Colors.black,
                        onPressed: () {},
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
                        onPressed: () {},
                        child: const Text("WISHLIST"),
                      ),
                    )
                  ],
                ),
              ),
              const AccountInfoText(title: ' Account Profile '),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey, width: 2.0)),
                child: Column(children: const [
                  ListTile(
                    leading: Icon(
                      Icons.email,
                    ),
                    title: Text("Your Email Address: "),
                    subtitle: Text("example@mail.com"),
                  ),
                  Divider(
                    height: 10.0,
                    thickness: 2.0,
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                    ),
                    title: Text("Your Phone No. : "),
                    subtitle: Text("+9111111"),
                  ),
                  Divider(
                    height: 10.0,
                    thickness: 2.0,
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                    ),
                    title: Text("Your Address: "),
                    subtitle: Text("BBSR , unit-4 "),
                  ),
                ]),
              ),
              const AccountInfoText(title: ' Account Settings '),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey, width: 2.0)),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.person,
                      ),
                      title: Text("Change Profile"),
                    ),
                    Divider(
                      height: 10.0,
                      thickness: 2.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.lock,
                      ),
                      title: Text("Change Password"),
                    ),
                    Divider(
                      height: 10.0,
                      thickness: 2.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                      ),
                      title: Text("Logout"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AccountInfoText extends StatelessWidget {
  final String title;
  const AccountInfoText({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50.0,
            height: 30.0,
            child: Divider(
              height: 10.0,
              color: Colors.amber,
              thickness: 5.0,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20.0, fontFamily: 'Poppins', color: Colors.grey),
          ),
          const SizedBox(
            width: 50.0,
            height: 30.0,
            child: Divider(
              height: 30.0,
              color: Colors.amber,
              thickness: 5.0,
            ),
          ),
        ],
      ),
    );
  }
}
