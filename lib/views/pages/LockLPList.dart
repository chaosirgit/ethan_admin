import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LockLpsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class LockLpList extends StatelessWidget {
  const LockLpList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Lock LP 列表",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Lock LP List",
                    attributeNames: ['公链名称','代币地址','代币名称','代币简称','代币小数位','交易对','当前锁仓金额'],
                    attributes:['chain_name','token_address','name','symbol','decimals','pair_name','current_amount'],
                    getData: (page,limit) async {
                  var res = await LockLpsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
