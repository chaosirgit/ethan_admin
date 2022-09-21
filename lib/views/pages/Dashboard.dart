import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/views/Layout.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(
                  title: "DashBoard",
                ),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(
                  onTap: (d, c) {
                    print(d);
                  },
                ),
              ],
            )));
  }
}
