import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:web3dart/contracts.dart';

import '../services/Web3Service.dart';
import 'helper.dart';

class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  String toString() {
    return this.message;
  }
}

class Task {
  String name = "";
  String contractName = "";
  double progress = 0; //进度
  String address = "";
  String chainName = "";
  int chainId = 0;
  DeployedContract externMasterContract;
  DeployedContract referralMasterContract;
  DeployedContract? tokenMasterContract;
  DeployedContract? launchpadMasterContract;
  DeployedContract? helperMasterContract;
  DeployedContract? lockMasterContract;
  ChainOrigin web3;
  bool running;
  bool _lock = false;

  Task(
      {required this.name,
      required this.contractName,
      required this.progress,
      required this.address,
      required this.chainName,
      required this.chainId,
      required this.externMasterContract,
      required this.referralMasterContract,
      this.tokenMasterContract,
      this.launchpadMasterContract,
      this.helperMasterContract,
      this.lockMasterContract,
      required this.web3,
      this.running = true});

  String toString() {
    return "Task: {name: $name,contractName: $contractName,progress: $progress,address: $address,chainName: $chainName,chainId: $chainId,externMasterContract: $externMasterContract, referralMasterContract: $referralMasterContract,tokenMasterContract: $tokenMasterContract,launchpadMasterContract: $launchpadMasterContract,helperMasterContract: $helperMasterContract,lockMasterContract: $lockMasterContract,running: $running,web3: $web3}";
  }

  static Future<Task> generateTask(ChainOrigin co, String contractName) async {
    var chainName = "";
    if (co.chainId == 1) {
      chainName = "以太坊";
    } else if (co.chainId == 56) {
      chainName = "币安链";
    } else if (co.chainId == 97) {
      chainName = "币安测试链";
    } else {
      throw TaskException("不支持的链ID");
    }
    var saleMasterContract = await getContract('SaleMaster.abi', co.saleMaster);
    var externMasterAddress = await co.client.call(
        contract: saleMasterContract,
        function: saleMasterContract.function('saleExtern'),
        params: []);
    if (externMasterAddress.isEmpty) {
      throw TaskException("未设置扩展合约");
    }
    var referralMasterAddress = await co.client.call(
        contract: saleMasterContract,
        function: saleMasterContract.function('referral'),
        params: []);
    if (referralMasterAddress.isEmpty) {
      throw TaskException("未设置邀请合约");
    }
    var externMasterContract = await getContract(
        'ExternMaster.abi', externMasterAddress[0].toString());
    var referralMasterContract = await getContract(
        'ReferralMaster.abi', referralMasterAddress[0].toString());
    var name = "";
    var tokenMasterContract = null;
    var launchpadMasterContract = null;
    var helperMasterContract = null;
    var lockMasterContract = null;
    var contractAddress = "";
    switch (contractName) {
      case "TokenMaster":
        name = "代币列表";
        var tokenMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('tokenMasters'),
            params: []);
        if (tokenMasterAddress.isEmpty) {
          throw TaskException("未设置 TokenMaster");
        }
        contractAddress = tokenMasterAddress[0].toString();
        tokenMasterContract =
            await getContract('TokenMaster.abi', contractAddress);
        break;
      case "LaunchpadMaster":
        name = "Launchpad列表";
        var launchpadMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('launchpadMasters'),
            params: []);
        if (launchpadMasterAddress.isEmpty) {
          throw TaskException("未设置 LaunchpadMaster");
        }
        contractAddress = launchpadMasterAddress[0].toString();
        launchpadMasterContract =
            await getContract('LaunchpadMaster.abi', contractAddress);
        // 获取Helper合约
        var helperMasterAddress = await co.client.call(
          contract: saleMasterContract,
          function: saleMasterContract.function('addressOf'),
          params: [
            BigInt.from(1001),
          ],
        );
        if (helperMasterAddress.isEmpty) {
          throw TaskException("未设置 Helper 合约");
        }
        helperMasterContract = await getContract(
            'HelperMaster.abi', helperMasterAddress[0].toString());
        break;
      case "LockNormalMaster":
        name = "Lock 仓库列表(普通)";
        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        lockMasterContract = await getContract('LockMaster.abi', lockMasterAddress[0].toString());
        break;
      case "LockLpMaster":
        name = "Lock 仓库列表(LP)";
        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        lockMasterContract = await getContract('LockMaster.abi', lockMasterAddress[0].toString());
        break;
      case "LockLogs":
        name = "Lock 锁仓记录";
        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        lockMasterContract = await getContract('LockMaster.abi', lockMasterAddress[0].toString());
        break;
      default:
        {
          throw TaskException("不支持的任务");
        }
    }
    return Task(
        name: name,
        contractName: contractName,
        progress: 0,
        address: contractAddress,
        chainName: chainName,
        chainId: co.chainId,
        externMasterContract: externMasterContract,
        referralMasterContract: referralMasterContract,
        tokenMasterContract: tokenMasterContract,
        launchpadMasterContract: launchpadMasterContract,
        helperMasterContract: helperMasterContract,
        lockMasterContract: lockMasterContract,
        web3: co);
  }

  Future<void> execute() async {
    if (progress < 1.0 && running) {
      while (running) {
        progress = await ExecuteTaskFactory.getFactory(this).execute(1);
      }
    }
  }

  Future<void> cancel() async {
    running = false;
  }

  Future<void> start() async {
    running = true;
    execute();
  }
}
