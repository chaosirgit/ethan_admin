import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/models/Stakes.dart';
import 'package:web3dart/credentials.dart';

class StakesExecute implements ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  StakesExecute(this.task);

  // 获取开始索引
  Future<int> getStartIndex() async {
    return await Stakes().count(where: "chain_id = ?",whereArgs: [task.chainId]);
  }

  // 记录是否全部同步完成
  bool isParsed(Map params) {
    return params['start_time'] as int > 0 && params["type"] != null;
  }

  // 获取链上记录总数
  Future<int> getTotalCount() async {
    var total = await task.web3.client.call(
        contract: task.externMasterContract,
        function: task.externMasterContract
            .function('tokenOfListLength'),
        params: [EthereumAddress.fromHex(task.address)]);
    return (total[0] as BigInt).toInt();
  }

  // 插入新记录到数据库
  // @totalCount 总记录数量
  // @startIndex 开始索引
  Future<void> insertNewToDatabase(int totalCount, int startIndex) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(Stakes().tableName,Stakes().fromMap({"chain_id":task.chainId,"chain_index":a}).toMap());
      }
      await batch.commit();
    }
  }

  // 获取未解析的链上索引列表
  Future<List<BigInt>> getUnParsedChainIndexList() async {
    var list = await Stakes().get(where: "chain_id = ? and is_parsed = 0", whereArgs: [task.chainId], orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  // 获取未解析地址列表
  Future<List<dynamic>> getUnParsedAddressList(List<BigInt> chainIndexList) async {
    var list = await task.web3.client.call(
        contract: task.externMasterContract,
        function: task.externMasterContract.function('tokenOfList'),
        params: [EthereumAddress.fromHex(task.address), chainIndexList]);
    return list[0];
  }
  // 根据未解析地址列表解析数据 返回进度
  // @seconds 间隔秒数
  Future<double> execute(int seconds) async {
    var totalCount = await getTotalCount();
    if (totalCount == 0){
      task.running = 3;
      return 1.0;
    }
    var startIndex = await getStartIndex();
    await insertNewToDatabase(totalCount, startIndex);
    var indexArr = await getUnParsedChainIndexList();
    var addressArr = await getUnParsedAddressList(indexArr);
    if (addressArr.isNotEmpty) {
      for (var i = 0; i < addressArr.length; i++) {
        var stakingContract = await getContract(
            'Staking.abi', addressArr[i].toString());
        //基础信息
        task.web3.client.call(
            contract: stakingContract,
            function: stakingContract.function('getConfig'),
            params: []).then((res) async {
                task.web3.client.call(
                    contract: task.externMasterContract,
                    function: task.externMasterContract.function('getTokenBase'),
                    params: [res[3],[BigInt.from(0)],[BigInt.from(0)]]).then((r) async {
                  if (!_lock) {
                    try {
                      _lock = true;
                      var staking = await Stakes().first(
                          where: "chain_id = ? and chain_index = ?",
                          whereArgs: [
                            task.chainId,
                            indexArr[i].toInt(),
                          ]);
                      if (staking["is_parsed"] != 1) {
                        staking["start_time"] = (res[0] as BigInt).toInt();
                        staking["end_time"] = (res[1] as BigInt).toInt();
                        staking["lock_period"] = (res[2] as BigInt).toInt();
                        staking["staking_address"] = addressArr[i].toString();
                        staking["token_address"] = res[3].toString();
                        staking["token_name"] = r[0];
                        staking["token_symbol"] = r[1];
                        staking["token_decimals"] = (r[2] as BigInt).toInt();
                        staking["reward_address"] = res[4].toString();
                        if (res[3] == res[4]){
                          staking["reward_name"] = r[0];
                          staking["reward_symbol"] = r[1];
                          staking["reward_decimals"] = (r[2] as BigInt).toInt();
                        }else{
                          var reward = await task.web3.client.call(
                            contract: task.externMasterContract,
                            function: task.externMasterContract.function('getTokenBase'),
                            params: [res[4],[BigInt.from(0)],[BigInt.from(0)]]);
                          staking["reward_name"] = reward[0];
                          staking["reward_symbol"] = reward[1];
                          staking["reward_decimals"] = (reward[2] as BigInt).toInt();
                        }
                        staking["apr"] = (res[5] as BigInt).toInt();
                        staking["pool_cap"] = (res[6] as BigInt).toString();
                        if (isParsed(staking)) {
                          staking["is_parsed"] = 1;
                        }
                        if (staking["id"] as int > 0) {
                          var a = await Stakes().fromMap(staking);
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
        });
        // 类型
        task.web3.client.call(
            contract: task.externMasterContract,
            function: task.externMasterContract.function('tokenOfParams256'),
            params: [addressArr[i],[BigInt.from(0)]]).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var staking = await Stakes().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (staking["is_parsed"] != 1) {
                staking["type"] = (res[0][0] as BigInt).toInt();
                if (isParsed(staking)) {
                  staking["is_parsed"] = 1;
                }
                if (staking["id"] as int > 0) {
                  var a = await Stakes().fromMap(staking);
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
    var parsedCount = await Stakes().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));

    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = 3;
    }
    return p;
  }
}