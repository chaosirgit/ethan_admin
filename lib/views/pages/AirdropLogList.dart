import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/AirdropLogsController.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LockLogsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/StakeLogsController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class AirdropLogList extends StatelessWidget {
  const AirdropLogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Airdrop 参与记录",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Airdrop Log List",
                    attributeNames: ['公链名称','Airdrop 合约地址','用户地址','空投类型','奖励金额'],
                    attributes:['chain_name','airdrop_address','address','type_name','rewards'],
                    getData: (page,limit) async {
                  var res = await AirdropLogsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
