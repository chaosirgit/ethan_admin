import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/StakesController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class StakeList extends StatelessWidget {
  const StakeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Staking 列表",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Staking List",
                    attributeNames: ['公链名称','合约地址','挖矿代币','奖励代币','开始时间','结束时间','APR'],
                    attributes:['chain_name','staking_address','token_symbol','reward_symbol','start_time_format','end_time_format','apr'],
                    getData: (page,limit) async {
                  var res = await StakesController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
