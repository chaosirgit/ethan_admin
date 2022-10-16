import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/LockLps.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:web3dart/credentials.dart';

class LocksLpMasterExecute implements ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;

  LocksLpMasterExecute(this.task);

  @override
  Future<double> execute(int seconds) async {
    var totalCount = await getTotalCount();
    var startIndex = await getStartIndex();
    await insertNewToDatabase(totalCount, startIndex);
    var indexArr = await getUnParsedChainIndexList();
    var addressArr = await getUnParsedAddressList(indexArr);
    if (addressArr.isNotEmpty) {
      for (var i = 0; i < addressArr.length; i++){
        task.web3.client.call(
            contract: task.externMasterContract,
            function: task.externMasterContract.function('getTokenBase'),
            params: [EthereumAddress.fromHex(addressArr[i][0].toString()),[BigInt.from(0)],[BigInt.from(0)]]).then((res) async {
              if (!_lock){
                try {
                  _lock = true;
                  var lock = await LockLps().first(
                      where: "chain_id = ? and chain_index = ?",
                      whereArgs: [
                        task.chainId,
                        indexArr[i].toInt(),
                      ]);
                  if (lock['is_parsed'] != 1){
                    lock['token_address'] = addressArr[i][0].toString();
                    lock['name'] = res[0];
                    lock['symbol'] = res[1];
                    lock['decimals'] = (res[2] as BigInt).toInt();
                    lock['factory_address'] = addressArr[i][1].toString();
                    lock['current_amount'] = (addressArr[i][2] as BigInt).toString();
                    var lpTokenContract = await getContract('LPToken.abi', addressArr[i][0].toString());
                    var token0Address = await task.web3.client.call(contract: lpTokenContract,function:lpTokenContract.function('token0'),params: []);
                    var token1Address = await task.web3.client.call(contract: lpTokenContract,function:lpTokenContract.function('token1'),params: []);
                    var token0 = await task.web3.client.call(
                      contract: task.externMasterContract,
                      function: task.externMasterContract.function('getTokenBase'),
                      params: [token0Address[0],[BigInt.from(0)],[BigInt.from(0)]]
                    );
                    var token1 = await task.web3.client.call(
                        contract: task.externMasterContract,
                        function: task.externMasterContract.function('getTokenBase'),
                        params: [token1Address[0],[BigInt.from(0)],[BigInt.from(0)]]
                    );
                    lock['token0_address'] = token0Address[0].toString();
                    lock['token0_name'] = token0[0];
                    lock['token0_symbol'] = token0[1];
                    lock['token0_decimals'] = (token0[2] as BigInt).toInt();
                    lock['token1_address'] = token1Address[0].toString();
                    lock['token1_name'] = token1[0];
                    lock['token1_symbol'] = token1[1];
                    lock['token1_decimals'] = (token1[2] as BigInt).toInt();
                    if (isParsed(lock)) {
                      lock["is_parsed"] = 1;
                    }
                    if (lock["id"] as int > 0) {
                      var a = await LockLps().fromMap(lock);
                      await a.save();
                    }
                  }
                } catch (e) {
                  print(e);
                } finally {
                  _lock = false;
                }
              }
        });
      }
    }
    //计算进度
    var parsedCount = await LockLps().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));
    if (totalCount == 0){
      task.running = 3;
      return 1.0;
    }
    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = 3;
    }
    return p;
  }

  @override
  Future<int> getStartIndex() async {
    // TODO: implement getStartIndex
    return await LockLps().count(where: "chain_id = ?",whereArgs: [task.chainId]);
  }

  @override
  Future<int> getTotalCount() async {
    // TODO: implement getTotalCount
    var total = await task.web3.client.call(
        contract: task.lockMasterContract!,
        function: task.lockMasterContract!
            .function('allLpTokenLockedCount'),
        params: []);
    return (total[0] as BigInt).toInt();
  }

  @override
  Future<List> getUnParsedAddressList(List<BigInt> chainIndexList) async {
    var result = [];
    if (chainIndexList.isNotEmpty){
      var list = await task.web3.client.call(
          contract: task.lockMasterContract!,
          function: task.lockMasterContract!.function('getCumulativeLpTokenLockInfo'),
          params: [chainIndexList[0], chainIndexList[chainIndexList.length - 1]]);
      result = list[0];
    }
    // 获取地址数组
    return result;
  }

  @override
  Future<List<BigInt>> getUnParsedChainIndexList() async {
    var list = await LockLps().get(where: "chain_id = ? and is_parsed = 0", whereArgs: [task.chainId],orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  // 插入新记录到数据库
  // @totalCount 总记录数量
  // @startIndex 开始索引
  @override
  Future<void> insertNewToDatabase(int totalCount, int startIndex) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(LockLps().tableName,LockLps().fromMap({"chain_id":task.chainId,"chain_index":a}).toMap());
      }
      await batch.commit();
    }
  }

  @override
  bool isParsed(Map params) {
    return params['token_address'] != "" && params['symbol'] != "";
  }

}