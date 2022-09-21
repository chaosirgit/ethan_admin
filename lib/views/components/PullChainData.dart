import 'package:ethan_admin/config/constants.dart';
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

  PullTask(
      {required this.name,
      required this.contractName,
      required this.progress,
      required this.address,
      required this.chainName,
      required this.chainId});
}

class PullChainDataController extends GetxController {
  RxList<PullTask> tasks = <PullTask>[].obs;
  final web3 = Get.find<Web3Service>();

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
        var contractAddress =
            EthereumAddress.fromHex(web3.chains[i].saleMaster);
        var abiString =
            await rootBundle.loadString('lib/resources/abis/SaleMaster.abi');
        var saleMasterContract = DeployedContract(
            ContractAbi.fromJson(abiString, 'SaleMaster'), contractAddress);
        var tokenMasterAddress = await web3.chains[i].client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('tokenMasters'),
            params: []);
        if (tokenMasterAddress.isNotEmpty) {
          tasks.value.add(PullTask(
              name: "代币列表",
              progress: 0,
              address: tokenMasterAddress[0].toString(),
              chainName: chainName,
              chainId: web3.chains[i].chainId,
              contractName: 'tokenMasters'));
          syncChainData();
          update();
        }
      }
    }
  }

  Future<void> syncChainData() async {
     for (var i = 0; i < tasks.length; i++){
       //异步 发送任务
       if (tasks.value[i].progress < 1.0){
         excuseTask(i);
       }
     }
     var done = tasks.value.where((task) {
       return task.progress < 1.0;
     }).toList();
     if (done.isEmpty){
       Get.snackbar("Success", "所有数据同步完成");
     }
  }
  //执行任务，更新进度 进度 = 插入数据库的数量 / (总数量 - 已经解析的数量)
  Future<void> excuseTask(int index) async {
    while (tasks.value[index].progress < 1.0){
      await Future.delayed(Duration(seconds: 1),() {
        tasks.value[index].progress += 0.1;
        var done = tasks.value.where((task) {
          return task.progress < 1.0;
        }).toList();
        if (done.isEmpty){
          Get.snackbar("Success", "所有数据同步完成");
        }
        update();
      });
    }
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
                  child:
                      ElevatedButton(onPressed: () {pcdc.init();}, child: Icon(Icons.sync)),
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
