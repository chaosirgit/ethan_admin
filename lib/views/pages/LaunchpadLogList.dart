import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadLogsController.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class LaunchpadLogList extends StatelessWidget {
  const LaunchpadLogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Launchpad 参与记录",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Launchpad Log List",
                    attributeNames: ['公链名称','Launchpad 合约地址','参与者','参与金额'],
                    attributes:['chain_name','launchpad_address','address','amount'],
                    getData: (page,limit) async {
                  var res = await LaunchPadLogsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
