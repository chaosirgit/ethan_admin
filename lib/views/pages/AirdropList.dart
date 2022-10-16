import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/AirdropsController.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/LocksController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class AirdropList extends StatelessWidget {
  const AirdropList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Airdrop 列表",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Airdrop List",
                    attributeNames: ['公链名称','名称','合约地址','空投代币简称','开始时间','结束时间','Top 奖励人数','Top 奖励','随机奖励人数','随机奖励'],
                    attributes:['chain_name','name','contract_address','token_symbol','start_time_format','end_time_format','top_count','top_rewards','random_count','random_rewards'],
                    getData: (page,limit) async {
                  var res = await AirdropsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
