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
  DeployedContract? lockMasterContract;
  DeployedContract? stakingMasterContract;
  ChainOrigin web3;
  int running; // 1 开始 2 停止 3 完成
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
      this.lockMasterContract,
      this.stakingMasterContract,
      required this.web3,
      this.running = 1});

  String toString() {
    return "Task: {name: $name,contractName: $contractName,progress: $progress,address: $address,chainName: $chainName,chainId: $chainId,externMasterContract: $externMasterContract, referralMasterContract: $referralMasterContract,tokenMasterContract: $tokenMasterContract,launchpadMasterContract: $launchpadMasterContract,lockMasterContract: $lockMasterContract, stakingMasterContract: $stakingMasterContract, running: $running,web3: $web3}";
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
    var lockMasterContract = null;
    var stakingMasterContract = null;
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
        name = "Launchpad 列表";
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
        break;
      case "LaunchpadLogs":
        name = "Launchpad 参与记录列表";
        break;
      case "LockNormalMaster":
        name = "Lock 仓库列表(普通)";

        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        contractAddress = lockMasterAddress[0].toString();
        lockMasterContract = await getContract('LockMaster.abi', contractAddress);
        break;
      case "LockLpMaster":
        name = "Lock 仓库列表(LP)";
        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        contractAddress = lockMasterAddress[0].toString();
        lockMasterContract = await getContract('LockMaster.abi', contractAddress);
        break;
      case "LockLogs":
        name = "Lock 锁仓记录";
        var lockMasterAddress = await co.client.call(
            contract: saleMasterContract,
            function: saleMasterContract.function('locking'), params: []);
        if (lockMasterAddress.isEmpty) {
          throw TaskException("未设置锁仓 lock 合约");
        }
        contractAddress = lockMasterAddress[0].toString();
        lockMasterContract = await getContract('LockMaster.abi', contractAddress);
        break;
      case "Stakes":
        name = "Staking 记录";
        var stakingMasterAddress = await co.client.call(
          contract: saleMasterContract,
          function: saleMasterContract.function('stakingMasters'), params: []);
        if (stakingMasterAddress.isEmpty) {
          throw TaskException("未设置 StakingMaster 合约");
        }
        contractAddress = stakingMasterAddress[0].toString();
        stakingMasterContract = await getContract('StakingMaster.abi', contractAddress);
        break;
      case "StakingLogs":
        name = "Staking Logs 记录";
        break;
      case "Airdrops":
        name = "Airdrops 记录";
        var airdropMasterAddress = await co.client.call(
          contract: saleMasterContract,
          function: saleMasterContract.function('airdropMasters'), params: []);
        if (airdropMasterAddress.isEmpty) {
          throw TaskException("未设置 AirdropMaster 合约");
        }
        contractAddress = airdropMasterAddress[0].toString();
        break;
      case "AirdropLogsTop":
        name = "Airdrop Top 名单记录";
        break;
      case "AirdropLogsRandom":
        name = "Airdrop Random 名单记录";
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
        lockMasterContract: lockMasterContract,
        stakingMasterContract: stakingMasterContract,
        web3: co);
  }

  Future<void> execute() async {
    // try {
    //   while (running == 1) {
    //     progress = await ExecuteTaskFactory.getFactory(this).execute(1);
    //   }
    // }catch (e) {
    //   throw e;
    // }
    while (running == 1) {
      progress = await ExecuteTaskFactory.getFactory(this).execute(1);
    }
  }

  Future<void> cancel() async {
    running = 2;
  }

  Future<void> start() async {
    running = 1;
  }
}
