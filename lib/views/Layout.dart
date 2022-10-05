import 'package:ethan_admin/views/components/PullChainData.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:ethan_admin/views/components/SideMenu.dart';
import 'package:ethan_admin/views/pages/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget currentWidget = DashBoard();

  void changeCurrent(Widget widget) {
    this.currentWidget = widget;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
    update();
  }

  void openDrawer() {
    if (!(_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
        _scaffoldKey.currentState?.openDrawer();
    }
  }
}

class Layout extends StatelessWidget {
  // Layout({Key? key,required this.child});
  Layout({Key? key}) : super(key : key);
  final LayoutController lc = Get.put(LayoutController());
  // Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: lc._scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea( //异形屏适配
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (GetPlatform.isDesktop)
              Expanded(
                child: SideMenu(),
              ),

            Expanded(
              flex: 5,
              // child: GetBuilder<LayoutController>(
              //   builder: (_) {
              //     return AnimatedSwitcher(
              //       duration: const Duration(milliseconds: 500),
              //       // transitionBuilder: (Widget child, Animation<double> animation) {
              //       //   // 执行缩放动画
              //       //   return ScaleTransition(
              //       //       child: child,
              //       //       scale: animation);
              //       //   // 旋转动画
              //       //   // return RotationTransition(
              //       //   //     child: child,
              //       //   //     turns: animation);
              //       // },
              //       child: lc.currentWidget
              //     );
              //   },
              // ),
              child: GetBuilder<LayoutController>(builder: (_) {
                return lc.currentWidget;
              },),
            ),
            Expanded(
              flex: 2,
              child: PullChainData(),
            ),
          ])),
    );
  }
}
