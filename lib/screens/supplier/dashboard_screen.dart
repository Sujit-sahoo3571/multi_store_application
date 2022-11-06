import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  final List<String> labels = const [
    'My Store',
    'Orders',
    'Manage Product',
    'Settings',
    'Balance',
    'Statistics',
  ];

  final List<IconData> icons = const [
    Icons.store,
    Icons.shopify,
    Icons.edit,
    Icons.settings_applications,
    Icons.currency_rupee,
    Icons.show_chart
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const AppbarTitle(subCategoryName: 'DashBoard'),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 15.0,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: List.generate(
              6,
              (index) => Card(
                    elevation: 25.0,
                    shadowColor: Colors.limeAccent,
                    color: Colors.lightBlueAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          icons[index],
                          size: 40.0,
                          color: Colors.yellowAccent,
                        ),
                        Text(
                          labels[index].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Poppins'),
                        )
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
