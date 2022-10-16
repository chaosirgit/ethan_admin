import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/views/Layout.dart';
import 'package:ethan_admin/views/pages/AirdropList.dart';
import 'package:ethan_admin/views/pages/AirdropLogList.dart';
import 'package:ethan_admin/views/pages/Dashboard.dart';
import 'package:ethan_admin/views/pages/LaunchpadList.dart';
import 'package:ethan_admin/views/pages/LaunchpadLogList.dart';
import 'package:ethan_admin/views/pages/LockLPList.dart';
import 'package:ethan_admin/views/pages/LockList.dart';
import 'package:ethan_admin/views/pages/LockLogList.dart';
import 'package:ethan_admin/views/pages/StakeList.dart';
import 'package:ethan_admin/views/pages/StakeLogList.dart';
import 'package:ethan_admin/views/pages/TokenList.dart';
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
          title: '代币列表',
          onTap: () => lc.changeCurrent(TokenList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Launchpad 列表',
          onTap: () => lc.changeCurrent(LaunchpadList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Launchpad 参与记录',
          onTap: () => lc.changeCurrent(LaunchpadLogList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Lock 普通仓库列表',
          onTap: () => lc.changeCurrent(LockList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Lock LP仓库列表',
          onTap: () => lc.changeCurrent(LockLpList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Lock 锁仓记录',
          onTap: () => lc.changeCurrent(LockLogList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Staking 列表',
          onTap: () => lc.changeCurrent(StakeList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Staking 记录列表',
          onTap: () => lc.changeCurrent(StakeLogList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Airdrop 项目列表',
          onTap: () => lc.changeCurrent(AirdropList()),
          leading: Icon(
            Icons.list,
            color: Colors.orange,
          )),
      new SideMenuRow(
          title: 'Airdrop 参与列表',
          onTap: () => lc.changeCurrent(AirdropLogList()),
          leading: Icon(
            Icons.list,
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
