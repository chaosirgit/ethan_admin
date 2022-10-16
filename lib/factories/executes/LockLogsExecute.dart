import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/LockLogs.dart';
import 'package:ethan_admin/models/Locks.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:web3dart/credentials.dart';

class LockLogsExecute extends ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  LockLogsExecute(this.task);

  @override
  Future<double> execute(int seconds) async {
    var locks = await Locks().get(where: "is_parsed = 1 and chain_id = ?",whereArgs: [task.chainId]);
    for (var i = 0; i < locks.length; i++){
      var tokenAddress = locks[i]['token_address'] as String;
      var totalCount = await getTotalCountByAddress(tokenAddress);
      var startIndex = await getStartIndexByAddress(tokenAddress);
      await insertNewToDatabaseByAddress(totalCount, startIndex,tokenAddress);
      var indexArr = await getUnParsedChainIndexListByAddress(tokenAddress);
      if (indexArr.isNotEmpty){
        task.web3.client.call(
            contract: task.lockMasterContract!,
            function: task.lockMasterContract!.function('getLocksForToken'),
            params: [EthereumAddress.fromHex(tokenAddress),indexArr[0],BigInt.from(totalCount - 1)]
        ).then((res) async {
          if (!_lock){
            try {
              _lock = true;
              var chainLogs = res[0] as List;
              if (chainLogs.isNotEmpty){
                for (var j = 0; j < chainLogs.length; j ++){
                  var log = await LockLogs().first(where: "chain_id = ? and chain_index = ? and token_address = ?",whereArgs: [task.chainId,indexArr[j].toInt(),tokenAddress]);
                  if (log['is_parsed'] != 1) {
                    log['chain_lock_id'] = (chainLogs[j][0] as BigInt).toInt();
                    log['owner'] = chainLogs[j][2].toString();
                    log['amount'] = chainLogs[j][3].toString();
                    log['lock_time'] = (chainLogs[j][4] as BigInt).toInt();
                    log['first_unlock_time'] = (chainLogs[j][5] as BigInt).toInt();
                    log['first_unlock_rate'] = (chainLogs[j][6] as BigInt).toInt();
                    log['unlock_cycle'] = (chainLogs[j][7] as BigInt).toInt();
                    log['unlock_cycle_rate'] = (chainLogs[j][8] as BigInt).toInt();
                    log['already_unlock_amount'] = (chainLogs[j][9] as BigInt).toString();
                    log['description'] = chainLogs[j][10];
                    if (isParsed(log)) {
                      log["is_parsed"] = 1;
                    }
                    if (log['id'] as int > 0){
                      var a = await LockLogs().fromMap(log);
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
    var parsedCount = await LockLogs().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    var totalCount = await LockLogs().count(where: "chain_id = ?",whereArgs: [task.chainId]);
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

  Future<int> getStartIndexByAddress(String tokenAddress) async {
    return await LockLogs().count(where: "chain_id = ? and token_address = ?",whereArgs: [task.chainId,tokenAddress]);
  }

  Future<int> getTotalCountByAddress(String tokenAddress) async {
    // TODO: implement getTotalCount
    var total = await task.web3.client.call(
        contract: task.lockMasterContract!,
        function: task.lockMasterContract!
            .function('totalLockCountForToken'),
        params: [EthereumAddress.fromHex(tokenAddress)]);
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
        batch.insert(LockLogs().tableName,LockLogs().fromMap({"chain_id":task.chainId,"chain_index":a,"token_address":tokenAddress}).toMap());
      }
      await batch.commit();
    }
  }


  @override
  Future<List<BigInt>> getUnParsedChainIndexListByAddress(String tokenAddress) async {
    var list = await LockLogs().get(where: "chain_id = ? and is_parsed = 0 and token_address = ?", whereArgs: [task.chainId,tokenAddress], orderBy: "chain_index asc");
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
    return params['chain_lock_id'] > 0;
  }
  
}