import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/controllers/TokensController.dart';
import 'package:ethan_admin/views/components/Header.dart';
import 'package:ethan_admin/views/components/PaginateList.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
class TokenList extends StatelessWidget {
  const TokenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: "代币列表",),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Search(onTap: (d,c) {
                  c.text = "";
                  print(d);
                },),
                PaginateList(header: "Tokens",
                    attributeNames: ['Logo','公链名称','拥有者','代币地址','类型','全称','简称','小数位','总发行量','是否开启机器人','KYC','Audit'],
                    attributes:['logo','chain_name','owner','token_address','type_name','name','symbol','decimals','total_supply','enable_bot','is_kyc','is_audit'],
                    getData: (page,limit) async {
                  var res = await TokensController().getPaginateList(page: page, limit: limit);
                  return res;
                })
              ],
            )
        ));
  }
}
