import 'dart:io';

import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/models/Tokens.dart';
import 'package:ethan_admin/services/Web3Service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class PullTask {
  String name = "";
  String contractName = "";
  double progress = 0; //进度
  String address = "";
  String chainName = "";
  int chainId = 0;
  DeployedContract? externMasterContract;
  DeployedContract? referralMasterContract;
  DeployedContract? tokenMasterContract;
  int web3ClientIndex = 0;
  bool running;

  PullTask(
      {required this.name,
      required this.contractName,
      required this.progress,
      required this.address,
      required this.chainName,
      required this.chainId,
      this.externMasterContract,
      this.referralMasterContract,
      this.tokenMasterContract,
      required this.web3ClientIndex,
      this.running = true});
}

class PullChainDataController extends GetxController {
  RxList<PullTask> tasks = <PullTask>[].obs;
  final web3 = Get.find<Web3Service>();
  bool tokenListLock = false;

  Future<void> init() async {
    tasks.value = [];
    for (var i = 0; i < web3.chains.length; i++) {
      if (web3.chains[i].saleMaster != "") {
        var chainName = "";
        if (web3.chains[i].chainId == 1) {
          chainName = "以太坊";
        } else if (web3.chains[i].chainId == 56) {
          chainName = "币安链";
        } else if (web3.chains[i].chainId == 97) {
          chainName = "币安测试链";
        }
        var saleMasterContract =
            await getContract('SaleMaster.abi', web3.chains[i].saleMaster);
        try {
          var externMasterAddress = await web3.chains[i].client.call(
              contract: saleMasterContract,
              function: saleMasterContract.function('saleExtern'),
              params: []);
          var referralMasterAddress = await web3.chains[i].client.call(
              contract: saleMasterContract,
              function: saleMasterContract.function('referral'),
              params: []);
          var tokenMasterAddress = await web3.chains[i].client.call(
              contract: saleMasterContract,
              function: saleMasterContract.function('tokenMasters'),
              params: []);
          if (externMasterAddress.isNotEmpty &&
              referralMasterAddress.isNotEmpty &&
              tokenMasterAddress.isNotEmpty) {
            var externMasterContract = await getContract(
                'ExternMaster.abi', externMasterAddress[0].toString());
            var referralMasterContract = await getContract(
                'ReferralMaster.abi', referralMasterAddress[0].toString());
            var tokenMasterContract = await getContract(
                'TokenMaster.abi', tokenMasterAddress[0].toString());
            if (tokenMasterAddress.isNotEmpty) {
              tasks.value.add(PullTask(
                  name: "代币列表",
                  progress: 0,
                  address: tokenMasterAddress[0].toString(),
                  chainName: chainName,
                  chainId: web3.chains[i].chainId,
                  contractName: 'tokenMasters',
                  externMasterContract: externMasterContract,
                  referralMasterContract: referralMasterContract,
                  tokenMasterContract: tokenMasterContract,
                  web3ClientIndex: i));
            }
            syncChainData();
            update();
          }
        } on SocketException catch (e) {
          print("连接断开: " + web3.chains[i].chainId.toString());
        }
      }
    }
  }

  Future<void> stop() async {
    tasks.value = tasks.value.map((t) {
      t.running = false;
      return t;
    }).toList();
    update();
  }

  Future<void> syncChainData() async {
    for (var i = 0; i < tasks.length; i++) {
      //异步 发送任务
      if (tasks.value[i].progress < 1.0) {
        excuseTask(i);
      }
    }
    var done = tasks.value.where((task) {
      return task.progress < 1.0;
    }).toList();
    if (done.isEmpty) {
      Get.snackbar("Success", "所有数据同步完成");
    }
  }


  //执行任务，更新进度 进度 = 插入数据库的数量 / (总数量 - 已经解析的数量)
  Future<void> excuseTask(int index) async {
    while (tasks.value[index].progress < 1.0 && tasks.value[index].running) {
      await Future.delayed(Duration(seconds: 1), () async {
        if (tasks.value[index].tokenMasterContract != null) {
          await tokenMastersSyncTask(tasks.value[index]);
        }
      });
    }
  }

  Future<void> tokenMastersSyncTask(PullTask tk) async {
    // 需要更新的记录
    var totalCount = await Tokens.needInsertIndex(web3.chains[tk.web3ClientIndex], tk);
    List<BigInt> indexArr = [];
    var unParsed = await Tokens.get(where: "chain_id = ? and is_parsed = 0",whereArgs: [web3.chains[tk.web3ClientIndex].chainId]);
    indexArr = unParsed.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
    // 全部解析完毕，任务完成
    if (indexArr.isEmpty) {
      tk.progress = 1.0;
      Get.snackbar("Success", "所有数据同步完成");
      update();
      return null;
    }
    // 获取代币地址数组
    var tokenAddressArray =
    await web3.chains[tk.web3ClientIndex].client.call(
        contract: tk.externMasterContract!,
        function: tk.externMasterContract!
            .function('tokenOfList'),
        params: [
          EthereumAddress.fromHex(tk.address),
          indexArr
        ]);
    // 解析
    if (tokenAddressArray[0].isNotEmpty) {
      for (var i = 0; i < tokenAddressArray[0].length; i++) {
        //基础信息
        web3.chains[tk.web3ClientIndex].client.call(
            contract: tk.externMasterContract!,
            function: tk.externMasterContract!
                .function('getTokenBase'),
            params: [
              tokenAddressArray[0][i],
              [BigInt.from(0), BigInt.from(100), BigInt.from(101)],
              [BigInt.from(0), BigInt.from(1), BigInt.from(2)]
            ]).then((res) async {
          if (tokenListLock) {
            return null;
          }
          tokenListLock = true;
          var token = await Tokens.first(
              where: "chain_id = ? and chain_index = ?",
              whereArgs: [
                web3.chains[tk.web3ClientIndex].chainId,
                indexArr[i].toInt(),
              ]);
          if (token["is_parsed"] == 1) {
            tokenListLock = false;
            return null;
          }
          token["name"] = res[0];
          token["symbol"] = res[1];
          token["chain_id"] =
              web3.chains[tk.web3ClientIndex].chainId;
          token["token_address"] = tokenAddressArray[0][i].toString();
          token["decimals"] = (res[2] as BigInt).toInt();
          token["type"] = (res[3][0] as BigInt).toInt();
          token["is_kyc"] = (res[3][1] as BigInt).toInt();
          token["is_audit"] = (res[3][2] as BigInt).toInt();
          token["logo"] =
          (res[4][2] as String).length > 200 ? "" : res[4][2] as String;
          if (token["decimals"] > 0 &&
              token["total_supply"] != "0"  &&
              token["owner"] != "" && token["enable_bot"] > -1) {
            token["is_parsed"] = 1;
          }
          if (token["id"] > 0){
            var a = await Tokens.fromMap(token);
            await a.save();
          }
          tokenListLock = false;
        });

        //总发行量
        var Erc20Contract = await getContract(
            'Erc20.abi', tokenAddressArray[0][i].toString());
        web3.chains[tk.web3ClientIndex].client.call(
            contract: Erc20Contract,
            function: Erc20Contract.function('totalSupply'),
            params: []).then((res) async {
          if (tokenListLock) {
            return null;
          }
          tokenListLock = true;
          var token = await Tokens.first(
              where: "chain_id = ? and chain_index = ?",
              whereArgs: [
                web3.chains[tk.web3ClientIndex].chainId,
                indexArr[i].toInt(),
              ]);
          if (token["is_parsed"] == 1) {
            tokenListLock = false;
            return null;
          }
          token["total_supply"] = (res[0] as BigInt).toString();
          token["chain_id"] =
              web3.chains[tk.web3ClientIndex].chainId;
          token["token_address"] = tokenAddressArray[0][i].toString();

          if (token["decimals"] > 0 &&
              token["total_supply"] != "0" &&
              token["owner"] != "" && token["enable_bot"] > -1) {
            token["is_parsed"] = 1;
          }
          if (token["id"] > 0){
            var a = await Tokens.fromMap(token);
            await a.save();
          }
          tokenListLock = false;
        });

        //owner and referral
        web3.chains[tk.web3ClientIndex].client.call(
            contract: tk.externMasterContract!,
            function: tk.externMasterContract!
                .function('getTokenInfo'),
            params: [
              tokenAddressArray[0][i],
              [BigInt.from(0)],
              [BigInt.from(0)],
              [BigInt.from(0), BigInt.from(1)]
            ]).then((res) {
          web3.chains[tk.web3ClientIndex].client.call(
              contract: tk.referralMasterContract!,
              function: tk.referralMasterContract!
                  .function('referralOf'),
              params: [
                res[0],
              ]).then((r) async {
            if (tokenListLock) {
              return null;
            }
            var token = await Tokens.first(
                where: "chain_id = ? and chain_index = ?",
                whereArgs: [
                  web3.chains[tk.web3ClientIndex].chainId,
                  indexArr[i].toInt(),
                ]);
            if (token["is_parsed"] == 1) {
              tokenListLock = false;
              return null;
            }
            token["chain_id"] =
                web3.chains[tk.web3ClientIndex].chainId;
            token["token_address"] = tokenAddressArray[0][i].toString();
            token["owner"] = res[0].toString();
            token["invite_address"] = r[0].toString();

            if (token["decimals"] > 0 &&
                token["total_supply"] != "0" &&
                token["owner"] != ""  && token["enable_bot"] > -1) {
              token["is_parsed"] = 1;
            }
            if (token['id'] > 0) {
              var a = await Tokens.fromMap(token);
              await a.save();
            }
            tokenListLock = false;
          });
        });

        //机器人
        web3.chains[tk.web3ClientIndex].client.call(
            contract: tk.tokenMasterContract!,
            function: tk.tokenMasterContract!
                .function('tokenAntiBot'),
            params: [
              tokenAddressArray[0][i],
            ]).then((res) async {
          if (tokenListLock) {
            return null;
          }
          var token = await Tokens.first(
              where: "chain_id = ? and chain_index = ?",
              whereArgs: [
                web3.chains[tk.web3ClientIndex].chainId,
                indexArr[i].toInt(),
              ]);
          token["chain_id"] =
              web3.chains[tk.web3ClientIndex].chainId;
          token["token_address"] = tokenAddressArray[0][i].toString();
          token["enable_bot"] = res[1] == true ? 1 : 0;

          if (token["decimals"] > 0 &&
              token["total_supply"] != "0" &&
              token["owner"] != "" && token["enable_bot"] > -1) {
            token["is_parsed"] = 1;
          }
          if (token['id'] > 0) {
            var a = await Tokens.fromMap(token);
            await a.save();
          }
          tokenListLock = false;
        });
        //更新进度
        var parsedCount = await Tokens.count(where:"chain_id = ? and is_parsed = 1",whereArgs: [web3.chains[tk.web3ClientIndex].chainId]);
        tk.progress = parsedCount / totalCount;
        update();
      }
    }
    //检测所有任务是否完成
    var done = tasks.value.where((task) {
      return task.progress < 1.0;
    }).toList();
    if (done.isEmpty) {
      Get.snackbar("Success", "所有数据同步完成");
    }
    update();
  }
}

class PullChainData extends StatelessWidget {
  PullChainData({Key? key}) : super(key: key);
  final PullChainDataController pcdc = Get.put(PullChainDataController());

  @override
  Widget build(BuildContext context) {
    pcdc.init();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "数据同步进度",
                    style: TextStyle(fontSize: smallTitle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              pcdc.init();
                            },
                            child: Icon(Icons.sync)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              pcdc.stop();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.red)),
                            child: Icon(Icons.pause_sharp)),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
          Expanded(
            child: GetBuilder<PullChainDataController>(
              builder: (_) {
                var children = <Widget>[];
                for (var i = 0; i < pcdc.tasks.length; i++) {
                  children.add(Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Text(
                          pcdc.tasks.value[i].chainName +
                              "-" +
                              pcdc.tasks.value[i].name,
                          style: TextStyle(fontSize: title),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        LinearProgressIndicator(
                          backgroundColor: Colors.white70,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: pcdc.tasks.value[i].progress,
                        ),
                      ],
                    ),
                  ));
                }
                return ListView(
                  children: children,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
