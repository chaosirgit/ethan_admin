import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/LaunchpadsController.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class LaunchpadList extends StatelessWidget {
  const LaunchpadList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "Launchpad 列表",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Launchpad List",
                    attributeNames: ['公链名称','发布者','拥有者','合约地址','类型','预售代币','支付代币','软顶','硬顶'],
                    attributes:['chain_name','publisher','owner','contract_address','type_name','presale_symbol','pay_symbol','soft_cap','hard_cap'],
                    getData: (page,limit) async {
                  var res = await LaunchpadsController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
