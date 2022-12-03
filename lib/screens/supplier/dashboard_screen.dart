import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_application/dashboard_component/dash_balance.dart';
import 'package:multi_store_application/dashboard_component/dash_mangeprod.dart';
import 'package:multi_store_application/dashboard_component/dash_order.dart';
import 'package:multi_store_application/dashboard_component/dash_settings.dart';
import 'package:multi_store_application/dashboard_component/dash_statistic.dart';
import 'package:multi_store_application/screens/vistit_store_screen.dart';
import 'package:multi_store_application/screens/welcome_screen.dart';
import 'package:multi_store_application/widgets/alertdialog.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

const List<String> labels = [
  'My Store',
  'Orders',
  'Manage Product',
  'Settings',
  'Balance',
  'Statistics',
];

const List<IconData> icons = [
  Icons.store,
  Icons.shopify,
  Icons.edit,
  Icons.settings_applications,
  Icons.currency_rupee,
  Icons.show_chart
];

List dashboardScreens = [
  // DashMyStore(),
  VisitStoreScreen(sid: FirebaseAuth.instance.currentUser!.uid),
  const DashOrderScreen(),
  const DashMangaeProduct(),
  const DashSettings(),
  const DashBalanceScreen(),
  const DashStatistic(),
];

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

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
            onPressed: () async {
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
            },
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
              (index) => InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dashboardScreens[index])),
                    child: Card(
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
                    ),
                  )),
        ),
      ),
    );
  }
}
