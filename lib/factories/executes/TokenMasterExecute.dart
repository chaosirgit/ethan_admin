import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/models/Tokens.dart';
import 'package:web3dart/credentials.dart';

class TokenMasterExecute implements ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  TokenMasterExecute(this.task);

  // 获取开始索引
  Future<int> getStartIndex() async {
    return await Tokens().count(where: "chain_id = ?",whereArgs: [task.chainId]);
  }

  // 记录是否全部同步完成
  bool isParsed(Map params) {
    return params['decimals'] as int > 0 && params["total_supply"] != "0" &&
        params["owner"] != "" &&
        params["enable_bot"] as int > -1;
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
        batch.insert(Tokens().tableName,Tokens().fromMap({"chain_id":task.chainId,"chain_index":a}).toMap());
      }
      await batch.commit();
    }
  }

  // 获取未解析的链上索引列表
  Future<List<BigInt>> getUnParsedChainIndexList() async {
    var list = await Tokens().get(where: "chain_id = ? and is_parsed = 0", whereArgs: [task.chainId]);
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
    var startIndex = await getStartIndex();
    await insertNewToDatabase(totalCount, startIndex);
    var indexArr = await getUnParsedChainIndexList();
    var addressArr = await getUnParsedAddressList(indexArr);
    if (addressArr.isNotEmpty){
      for (var i = 0; i < addressArr.length; i++) {
        //基础信息
        task.web3.client.call(
            contract: task.externMasterContract,
            function: task.externMasterContract.function('getTokenBase'),
            params: [
              addressArr[i],
              [BigInt.from(0), BigInt.from(100), BigInt.from(101)],
              [BigInt.from(0), BigInt.from(1), BigInt.from(2)]
            ]).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var token = await Tokens().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (token["is_parsed"] != 1) {
                token["name"] = res[0];
                token["symbol"] = res[1];
                token["token_address"] = addressArr[i].toString();
                token["decimals"] = (res[2] as BigInt).toInt();
                token["type"] = (res[3][0] as BigInt).toInt();
                token["is_kyc"] = (res[3][1] as BigInt).toInt();
                token["is_audit"] = (res[3][2] as BigInt).toInt();
                token["logo"] = (res[4][2] as String).length > 200
                    ? ""
                    : res[4][2] as String;
                if (isParsed(token)) {
                  token["is_parsed"] = 1;
                }
                if (token["id"] as int > 0) {
                  var a = await Tokens().fromMap(token);
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

        //总发行量
        var Erc20Contract =
        await getContract('Erc20.abi', addressArr[i].toString());
        task.web3.client.call(
            contract: Erc20Contract,
            function: Erc20Contract.function('totalSupply'),
            params: []).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var token = await Tokens().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (token["is_parsed"] != 1) {
                token["total_supply"] = (res[0] as BigInt).toString();

                if (isParsed(token)) {
                  token["is_parsed"] = 1;
                }
                if (token["id"] as int > 0) {
                  var a = await Tokens().fromMap(token);
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

        //owner and referral
        task.web3.client.call(
            contract: task.externMasterContract,
            function: task.externMasterContract.function('getTokenInfo'),
            params: [
              addressArr[i],
              [BigInt.from(0)],
              [BigInt.from(0)],
              [BigInt.from(0), BigInt.from(1)]
            ]).then((res) {
          task.web3.client.call(
              contract: task.referralMasterContract,
              function: task.referralMasterContract.function('referralOf'),
              params: [
                res[0],
              ]).then((r) async {
            if (!_lock) {
              try {
                var token = await Tokens().first(
                    where: "chain_id = ? and chain_index = ?",
                    whereArgs: [
                      task.chainId,
                      indexArr[i].toInt(),
                    ]);
                if (token["is_parsed"] != 1) {
                  token["owner"] = res[0].toString();
                  token["invite_address"] = r[0].toString();

                  if (isParsed(token)) {
                    token["is_parsed"] = 1;
                  }
                  if (token['id'] as int > 0) {
                    var a = await Tokens().fromMap(token);
                    await a.save();
                  }
                }
              } catch (e) {
                print("$e");
              } finally {
                _lock = false;
              }
            }
          });
        });

        //机器人
        task.web3.client.call(
            contract: task.tokenMasterContract!,
            function: task.tokenMasterContract!.function('tokenAntiBot'),
            params: [
              addressArr[i],
            ]).then((res) async {
          if (!_lock) {
            try {
              var token = await Tokens().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (token["is_parsed"] != 1) {
                token["enable_bot"] = res[1] == true ? 1 : 0;

                if (isParsed(token)) {
                  token["is_parsed"] = 1;
                }
                if (token['id'] as int > 0) {
                  var a = await Tokens().fromMap(token);
                  await a.save();
                }
              }
            } catch (e) {
              print("$e");
            } finally {
              _lock = false;
            }
          }
        });
      }
    }
    //计算进度
    var parsedCount = await Tokens().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));
    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = 3;
    }
    return p;
  }
}