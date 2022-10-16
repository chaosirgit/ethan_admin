import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LockLogsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class LockLogList extends StatelessWidget {
  const LockLogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Lock 锁仓记录",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Lock Log List",
                    attributeNames: ['公链名称','锁仓 ID','参与者地址','锁仓代币地址','锁仓金额','锁仓时间','首次解锁时间'],
                    attributes:['chain_name','chain_lock_id','owner','token_address','amount','lock_time_format','first_unlock_time_format'],
                    getData: (page,limit) async {
                  var res = await LockLogsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
