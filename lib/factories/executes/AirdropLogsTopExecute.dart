import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/models/AirdropLogs.dart';
import 'package:ethan_admin/models/Airdrops.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/helpers/task.dart';


class AirdropLogsTopExecute extends ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  AirdropLogsTopExecute(this.task);

  @override
  Future<double> execute(int seconds) async {
    var airdrops = await Airdrops().get(where: "is_parsed = 1 and chain_id = ?",whereArgs: [task.chainId]);
    for (var i = 0; i < airdrops.length; i++) {
      var airdropAddress = airdrops[i]['contract_address'] as String;
      var totalCount = await getTotalCountByAddress(airdropAddress);
      var startIndex = await getStartIndexByAddress(airdropAddress);
      await insertNewToDatabaseByAddress(totalCount, startIndex, airdropAddress);
      var indexArr = await getUnParsedChainIndexListByAddress(airdropAddress);
      if (indexArr.isNotEmpty) {
        var airdropContract = await getContract('Airdrop.abi', airdropAddress);
        task.web3.client.call(
          contract: airdropContract,
          function: airdropContract.function('listOfTop'),
          params: [indexArr[0],BigInt.from(indexArr.length)]
        ).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var logs = res[1] as List;
              if (logs.isNotEmpty) {
                for (var j = 0; j < logs.length; j++){
                  var log = await AirdropLogs().first(where:"chain_id = ? and chain_index = ? and airdrop_address = ? and type = 1", whereArgs: [task.chainId,indexArr[j].toInt(),airdropAddress]);
                  if (log['is_parsed'] != 1) {
                    log['address'] = logs[j].toString();
                    log['rewards'] = airdrops[i]['top_rewards'];
                    if (isParsed(log)){
                      log["is_parsed"] = 1;
                    }
                    if (log['id'] as int > 0){
                      var a = await AirdropLogs().fromMap(log);
                      await a.save();
                    }
                    task.web3.client.call(
                      contract: airdropContract,
                      function: airdropContract.function('claims'), params: [logs[j]]
                    ).then((r) async {
                      log['claimed'] = (r[0] as BigInt).toString();
                      if (isParsed(log)) {
                        log["is_parsed"] = 1;
                      }
                      if (log['id'] as int > 0){
                        var a = await AirdropLogs().fromMap(log);
                        await a.save();
                      }
                    });
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
    var parsedCount = await AirdropLogs().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    var totalCount = await AirdropLogs().count(where: "chain_id = ?",whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));
    if (totalCount == 0){
      return 0.0;
    }
    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = false;
    }
    return p;
  }

  Future<int> getStartIndexByAddress(String tokenAddress) async {
    return await AirdropLogs().count(where: "chain_id = ? and type = 1 and airdrop_address = ?",whereArgs: [task.chainId, tokenAddress]);
  }

  Future<int> getTotalCountByAddress(String tokenAddress) async {
    var contract = await getContract('Airdrop.abi', tokenAddress);
    var total = await task.web3.client.call(
      contract: contract,
      function: contract.function('listOfTop'), params: [BigInt.from(0), BigInt.from(1)]
    );
    return (total[0] as BigInt).toInt();
  }

  Future<List<BigInt>> getUnParsedChainIndexListByAddress(String tokenAddress) async {
    var list = await AirdropLogs().get(where: "chain_id = ? and is_parsed = 0 and airdrop_address = ? and type = 1",whereArgs: [task.chainId,tokenAddress],orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  Future<void> insertNewToDatabaseByAddress(int totalCount, int startIndex, String tokenAddress) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(AirdropLogs().tableName,AirdropLogs().fromMap({"chain_id":task.chainId,"chain_index":a,"airdrop_address":tokenAddress,"type":1}).toMap());
      }
      await batch.commit();
    }
  }

  @override
  Future<int> getStartIndex() {
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
    return params['address'] != "" && params['claimed'] != "";
  }
  
}