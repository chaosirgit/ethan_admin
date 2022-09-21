import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/views/Layout.dart';
import 'package:ethan_admin/views/pages/Dashboard.dart';
import 'package:ethan_admin/views/pages/MyList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuRow {
  String title;
  void onTap;
  Widget leading;

  SideMenuRow(
      {required this.title, required this.leading, required this.onTap});
}

class SideMenuController extends GetxController {
  List items = <SideMenuRow>[];

  SideMenuController() {
    final LayoutController lc = Get.put(LayoutController());
    this.items = [
      new SideMenuRow(
          title: 'Dashboard',
          onTap: () => lc.changeCurrent(DashBoard()),
          leading: Icon(
            Icons.dashboard,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'List Page',
          onTap: () => lc.changeCurrent(MyList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Form Page',
          onTap: () => Get.toNamed('/dashboard'),
          leading: Icon(
            Icons.sanitizer,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Card Page',
          onTap: () => lc.changeCurrent(MyList()),
          leading: Icon(
            Icons.sanitizer,
            color: Colors.orange,
          )),
    ];
  }
}

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  final SideMenuController smc = Get.put(SideMenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.currency_bitcoin,
                size: 150.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              child: GetBuilder<SideMenuController>(
                builder: (_) {
                  return Column(
                      children: smc.items.map((e) {
                    return ListTile(
                      horizontalTitleGap: 0,
                      title: Text(
                        "${e.title}",
                        style: TextStyle(
                            color: Colors.white54, fontSize: smallTitle),
                      ),
                      leading: e.leading,
                      onTap: e.onTap,
                    );
                  }).toList());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
