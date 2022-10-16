import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LockLogsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/StakeLogsController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class StakeLogList extends StatelessWidget {
  const StakeLogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Staking 记录",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Staking Log List",
                    attributeNames: ['公链名称','Staking 合约地址','参与者地址','挖矿金额','解锁时间','最近参与时间'],
                    attributes:['chain_name','staking_address','owner','amount','unlock_time_format','last_time_format'],
                    getData: (page,limit) async {
                  var res = await StakeLogsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
