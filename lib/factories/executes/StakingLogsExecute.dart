import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';

import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/models/Stakes.dart';
import 'package:ethan_admin/models/StakingLogs.dart';


class StakingLogsExecute extends ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  StakingLogsExecute(this.task);

  @override
  Future<double> execute(int seconds) async {
    var stakes = await Stakes().get(where: "is_parsed = 1 and chain_id = ?",whereArgs: [task.chainId]);
    for (var i = 0; i < stakes.length; i++){
      var stakingAddress = stakes[i]['staking_address'] as String;
      var totalCount = await getTotalCountByAddress(stakingAddress);
      var startIndex = await getStartIndexByAddress(stakingAddress);
      await insertNewToDatabaseByAddress(totalCount, startIndex,stakingAddress);
      var indexArr = await getUnParsedChainIndexListByAddress(stakingAddress);
      if (indexArr.isNotEmpty){
        var stakingContract = await getContract('Staking.abi', stakingAddress);
        task.web3.client.call(
            contract: stakingContract,
            function: stakingContract.function('listOf'),
            params: [indexArr[0],BigInt.from(totalCount)]
        ).then((res) async {
          if (!_lock){
            try {
              _lock = true;
              var logs = res[0] as List;
              if (logs.isNotEmpty){
                for (var j = 0; j < logs.length; j ++){
                  var log = await StakingLogs().first(where: "chain_id = ? and chain_index = ? and staking_address = ?",whereArgs: [task.chainId,indexArr[j].toInt(),stakingAddress]);
                  if (log['is_parsed'] != 1) {
                    log['owner'] = logs[j][0].toString();
                    log['amount'] = logs[j][1].toString();
                    log['unlock_time'] = (logs[j][2] as BigInt).toInt();
                    log['last_time'] = (logs[j][4] as BigInt).toInt();
                    if (isParsed(log)) {
                      log["is_parsed"] = 1;
                    }
                    if (log['id'] as int > 0){
                      var a = await StakingLogs().fromMap(log);
                      await a.save();
                    }
                  }
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
    var parsedCount = await StakingLogs().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    var totalCount = await StakingLogs().count(where: "chain_id = ?",whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));
    if (totalCount == 0){
      return 0.0;
    }
    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = 3;
    }
    return p;
  }

  Future<int> getStartIndexByAddress(String tokenAddress) async {
    return await StakingLogs().count(where: "chain_id = ? and staking_address = ?",whereArgs: [task.chainId,tokenAddress]);
  }

  Future<int> getTotalCountByAddress(String tokenAddress) async {
    // TODO: implement getTotalCount
    var contract = await getContract('Staking.abi', tokenAddress);
    var total = await task.web3.client.call(
        contract: contract,
        function: contract
            .function('getStakingListLength'),
        params: []);
    return (total[0] as BigInt).toInt();
  }


  // 插入新记录到数据库
  // @totalCount 总记录数量
  // @startIndex 开始索引
  @override
  Future<void> insertNewToDatabaseByAddress(int totalCount, int startIndex, String tokenAddress) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(StakingLogs().tableName,StakingLogs().fromMap({"chain_id":task.chainId,"chain_index":a,"staking_address":tokenAddress}).toMap());
      }
      await batch.commit();
    }
  }


  @override
  Future<List<BigInt>> getUnParsedChainIndexListByAddress(String tokenAddress) async {
    var list = await StakingLogs().get(where: "chain_id = ? and is_parsed = 0 and staking_address = ?", whereArgs: [task.chainId,tokenAddress], orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }


  @override
  Future<int> getStartIndex() {
    // TODO: implement getStartIndex
    throw UnimplementedError();
  }

  @override
  Future<int> getTotalCount() {
    // TODO: implement getTotalCount
    throw UnimplementedError();
  }

  @override
  Future<List> getUnParsedAddressList(List<BigInt> chainIndexList) {
    // TODO: implement getUnParsedAddressList
    throw UnimplementedError();
  }

  @override
  Future<List<BigInt>> getUnParsedChainIndexList() {
    // TODO: implement getUnParsedChainIndexList
    throw UnimplementedError();
  }

  @override
  Future<void> insertNewToDatabase(int totalCount, int startIndex) {
    // TODO: implement insertNewToDatabase
    throw UnimplementedError();
  }

  @override
  bool isParsed(Map params) {
    // TODO: implement isParsed
    return params['owner'] != "";
  }
}