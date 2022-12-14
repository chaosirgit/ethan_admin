import 'package:ethan_admin/config/constants.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../views/pages/Init.dart';

class ChainOrigin {
  int chainId;
  String rpc;
  String saleMaster;
  late final Web3Client client;

  ChainOrigin(
      {required this.chainId, required this.rpc, required this.saleMaster}) {
    var httpClient = Client();
    this.client = Web3Client(this.rpc, httpClient);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "ChainOrigin: {chainId:$chainId, rpc:$rpc, saleMaster:$saleMaster}";
  }

  resetClient() {
    var httpClient = Client();
    this.client = Web3Client(this.rpc, httpClient);
  }

  factory ChainOrigin.create({chainId, rpc, saleMaster}) {
    return ChainOrigin(chainId: chainId, rpc: rpc, saleMaster: saleMaster);
  }
}

//web3
final List<ChainOrigin> CHAIN_ORIGIN = <ChainOrigin>[
  ChainOrigin.create(
    chainId: 1,
    rpc: "https://cloudflare-eth.com",
    saleMaster: ETH_SALE_MASTER_ADDRESS,
  ),
  ChainOrigin.create(
      chainId: 56, rpc: "https://bsc-dataseed1.binance.org", saleMaster: BNB_SALE_MASTER_ADDRESS),
  ChainOrigin.create(
      chainId: 97,
      rpc: "https://data-seed-prebsc-1-s1.binance.org:8545",
      // rpc: "https://data-seed-prebsc-1-s2.binance.org:8545",
      saleMaster: BNB_TEST_SALE_MASTER_ADDRESS),
  ChainOrigin.create(
    chainId: 5,
    rpc: "https://rpc.ankr.com/eth_goerli",
    saleMaster: ETH_TEST_SALE_MASTER_ADDRESS,
  )
];

class Web3Service extends GetxService {
  late final List<ChainOrigin> chains;
  final InitController ic = Get.put(InitController());

  Future<Web3Service> init() async {

    chains = CHAIN_ORIGIN.map( (co) {
      String serverName = "";
      if (co.chainId == 1) {
        serverName = "以太坊 Web3 通信";
      } else if (co.chainId == 56) {
        serverName = "币安链 Web3 通信";
      } else if (co.chainId == 97) {
        serverName = "币安测试 Web3 通信";
      } else if (co.chainId == 5) {
        serverName = "以太测试 Web3 通信";
      }
      try {
        ic.changeMessages(ServiceStatus(name: serverName, successful: 3));
        if (co.client == null) {
          var httpClient = Client();
          var ethereumClient = Web3Client(co.rpc, httpClient);
          co.client = ethereumClient;
        }
        ic.changeMessages(ServiceStatus(name: serverName, successful: 1));
        return co;
      } catch (e) {
        print(e.toString());
        ic.changeMessages(ServiceStatus(name: serverName, successful: 2));
        return co;
      }
    }).toList();
    return this;
  }
}
