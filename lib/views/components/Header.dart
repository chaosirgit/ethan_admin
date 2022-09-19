import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/views/Layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  String title;
  Header({Key? key,required this.title}) : super(key: key);

  LayoutController lc = Get.put(LayoutController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (GetPlatform.isMobile)
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              lc.openDrawer();
            },
          ),
        Text("$title",style: TextStyle(fontSize: middleTitle,color: Colors.white54),)
      ],
    );
  }
}
