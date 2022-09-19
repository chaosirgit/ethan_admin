import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:flutter/material.dart';

class MyList extends StatelessWidget {
  const MyList({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "List Page",)
              ],
            )
        ));
  }
}
