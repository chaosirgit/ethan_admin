import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/models/LaunchpadLogs.dart';
import 'package:ethan_admin/models/Launchpads.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:web3dart/credentials.dart';


class LaunchpadLogsExecute extends ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  LaunchpadLogsExecute(this.task);

  @override
  Future<double> execute(int seconds) async {
    var launchpads = await Launchpads().get(where: "is_parsed = 1 and chain_id = ?",whereArgs: [task.chainId]);
    for (var i = 0; i < launchpads.length; i++) {
      var launchpadAddress = launchpads[i]['contract_address'] as String;
      var totalCount = await getTotalCountByAddress(launchpadAddress);
      var startIndex = await getStartIndexByAddress(launchpadAddress);
      await insertNewToDatabaseByAddress(totalCount, startIndex, launchpadAddress);
      var indexArr = await getUnParsedChainIndexListByAddress(launchpadAddress);
      if (indexArr.isNotEmpty) {
        task.web3.client.call(
          contract: task.helperMasterContract!,
          function: task.helperMasterContract!.function('SaleList'),
          params: [EthereumAddress.fromHex(launchpadAddress),indexArr[0],BigInt.from(totalCount)]
        ).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var addressLogs = res[1] as List;
              var amountLogs = res[2] as List;
              if (addressLogs.isNotEmpty) {
                for (var j = 0; j < indexArr.length; j++){
                  var log = await LaunchpadLogs().first(where:"chain_id = ? and chain_index = ? and launchpad_address = ?", whereArgs: [task.chainId,indexArr[j].toInt(),launchpadAddress]);
                  if (log['is_parsed'] != 1) {
                    log['address'] = addressLogs[j].toString();
                    log['amount'] = amountLogs[j].toString();
                    if (isParsed(log)){
                      log["is_parsed"] = 1;
                    }
                    if (log['id'] as int > 0){
                      var a = await LaunchpadLogs().fromMap(log);
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
    var parsedCount = await LaunchpadLogs().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    var totalCount = await LaunchpadLogs().count(where: "chain_id = ?",whereArgs: [task.chainId]);
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
    return await LaunchpadLogs().count(where: "chain_id = ? and launchpad_address = ?",whereArgs: [task.chainId, tokenAddress]);
  }

  Future<int> getTotalCountByAddress(String tokenAddress) async {
    var total = await task.web3.client.call(
      contract: task.helperMasterContract!,
      function: task.helperMasterContract!.function('SaleList'), params: [EthereumAddress.fromHex(tokenAddress),BigInt.from(0), BigInt.from(1)]
    );
    return (total[0] as BigInt).toInt();
  }

  Future<List<BigInt>> getUnParsedChainIndexListByAddress(String tokenAddress) async {
    var list = await LaunchpadLogs().get(where: "chain_id = ? and is_parsed = 0 and launchpad_address = ?",whereArgs: [task.chainId,tokenAddress],orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  Future<void> insertNewToDatabaseByAddress(int totalCount, int startIndex, String tokenAddress) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(LaunchpadLogs().tableName,LaunchpadLogs().fromMap({"chain_id":task.chainId,"chain_index":a,"launchpad_address":tokenAddress}).toMap());
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
    return params['address'] != "";
  }
}