import 'package:ethan_admin/services/Web3Service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class PullTask {
  String name = "";
  double progress = 0; //进度
  String address = "";
  String chainName = "";
  PullTask(String name, double progress,String address,String chainName){
    this.name = name;
    this.progress = progress;
    this.address = address;
    this.chainName = chainName;
  }
}

class PullChainDataController extends GetxController {
  RxList<PullTask> tasks = <PullTask>[].obs;
  Rx<double> value = 0.0.obs;
  final web3 = Get.find<Web3Service>();

  Future<void> init() async {
    for (var i = 0; i < web3.chains.length; i++) {
      if (web3.chains[i].saleMaster != "") {
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
        print(tokenMasterAddress);
      }
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
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation(Colors.blue),
        value: 10,
      ),
    );
  }
}
