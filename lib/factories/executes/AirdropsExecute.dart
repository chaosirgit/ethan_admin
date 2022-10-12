import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Airdrops.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:web3dart/credentials.dart';


class AirdropsExecute extends ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  AirdropsExecute(Task this.task);
  @override
  Future<double> execute(int seconds) async {
    var totalCount = await getTotalCount();
    var startIndex = await getStartIndex();
    await insertNewToDatabase(totalCount, startIndex);
    var indexArr = await getUnParsedChainIndexList();
    var addressArr = await getUnParsedAddressList(indexArr);
    if (addressArr.isNotEmpty) {
      for (var i = 0; i < addressArr.length; i++) {
        var airdropContract = await getContract('Airdrop.abi', addressArr[i].toString());
        //owner + invite_address
        task.web3.client.call(
          contract: task.externMasterContract,
          function: task.externMasterContract.function('getTokenInfo'),
          params: [
            addressArr[i],
            [BigInt.from(0)],
            [BigInt.from(0)],
            [BigInt.from(0), BigInt.from(1)],
          ],
        ).then((res) async {
          task.web3.client.call(
            contract: task.referralMasterContract,
            function: task.referralMasterContract.function('referralOf'),
            params: [res[0]]
          ).then((r) async {
            if (!_lock) {
              try {
                _lock = true;
                var airdrop = await Airdrops().first(
                    where: "chain_id = ? and chain_index = ?",
                    whereArgs: [task.chainId, indexArr[i].toInt()]);
                if (airdrop['is_parsed'] != 1) {
                  airdrop["owner"] = res[0].toString();
                  airdrop["invite_address"] = r[0].toString();
                  if (isParsed(airdrop)) {
                    airdrop["is_parsed"] = 1;
                  }
                  if (airdrop["id"] as int > 0) {
                    var a = await Airdrops().fromMap(airdrop);
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

        //基础信息 + 奖励代币信息
        task.web3.client.call(
            contract: airdropContract,
            function: airdropContract.function('getConfig'),
            params: []).then((res) async {
          task.web3.client.call(
              contract: task.externMasterContract,
              function: task.externMasterContract.function('getTokenBase'),
              params: [
                res[0],
                [BigInt.from(0)],
                [BigInt.from(0)]
              ]).then((r) async {
            if (!_lock) {
              try {
                _lock = true;
                var airdrop = await Airdrops().first(
                    where: "chain_id = ? and chain_index = ?",
                    whereArgs: [
                      task.chainId,
                      indexArr[i].toInt(),
                    ]);
                if (airdrop["is_parsed"] != 1) {
                  airdrop["token_address"] = res[0].toString();
                  airdrop["token_name"] = r[0];
                  airdrop["token_symbol"] = r[1];
                  airdrop["token_decimals"] = (r[2] as BigInt).toInt();
                  airdrop["start_time"] = (res[1] as BigInt).toInt();
                  airdrop["end_time"] = (res[2] as BigInt).toInt();
                  airdrop["top_count"] = (res[3] as BigInt).toInt();
                  airdrop["top_rewards"] = (res[4] as BigInt).toString();
                  airdrop["random_count"] = (res[5] as BigInt).toInt();
                  airdrop["random_rewards"] = (res[6] as BigInt).toString();
                  if (isParsed(airdrop)) {
                    airdrop["is_parsed"] = 1;
                  }
                  if (airdrop['id'] as int > 0) {
                    var a = await Airdrops().fromMap(airdrop);
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



        //文本参数
        task.web3.client.call(
            contract: task.externMasterContract,
            function: task.externMasterContract.function('tokenOfText'),
            params: [
              addressArr[i],
              [
                BigInt.from(0),
                BigInt.from(1),
                BigInt.from(2),
                BigInt.from(3),
                BigInt.from(4),
                BigInt.from(5),
                BigInt.from(6),
                BigInt.from(7),
                BigInt.from(8),
                BigInt.from(9),
                BigInt.from(10),
                BigInt.from(11),
                BigInt.from(12),
                BigInt.from(13),
                BigInt.from(14),
                BigInt.from(15),
                BigInt.from(16),
                BigInt.from(17),
                BigInt.from(18),
                BigInt.from(19),
              ]
            ]).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var airdrop = await Airdrops().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (airdrop["is_parsed"] != 1) {
                airdrop['contract_address'] = addressArr[i].toString();
                airdrop["name"] = res[0][0];
                airdrop["website"] = res[0][1];
                airdrop["banner"] = res[0][2];
                airdrop["logo"] = res[0][3];
                airdrop["description"] = res[0][4];

                airdrop["twitter_task"] = res[0][5];
                airdrop["twitter_point"] = stringToInt(res[0][6]);
                airdrop["tweets_task"] = res[0][7];
                airdrop["tweets_point"] = stringToInt(res[0][8]);
                airdrop["telegram_group_task"] = res[0][9];
                airdrop["telegram_group_point"] = stringToInt(res[0][10]);
                airdrop["telegram_channel_task"] = res[0][11];
                airdrop["telegram_channel_point"] = stringToInt(res[0][12]);
                airdrop["discord_task"] = res[0][13];
                airdrop["discord_point"] = stringToInt(res[0][14]);
                airdrop["youtube_task"] = res[0][15];
                airdrop["youtube_point"] = stringToInt(res[0][16]);
                airdrop["custom_task"] = res[0][17];
                airdrop["custom_point"] = stringToInt(res[0][18]);
                airdrop["refer_point"] = stringToInt(res[0][19]);

                if (isParsed(airdrop)) {
                  airdrop["is_parsed"] = 1;
                }
                if (airdrop['id'] as int > 0) {
                  var a = await Airdrops().fromMap(airdrop);
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
    var parsedCount = await Airdrops().count(
        where: "chain_id = ? and is_parsed = 1", whereArgs: [task.chainId]);
    await Future.delayed(Duration(seconds: seconds));
    var p = parsedCount / totalCount;
    if (p == 1.0) {
      task.running = 3;
    }
    return p;
  }

  @override
  Future<int> getStartIndex() async {
    return await Airdrops().count(where: "chain_id = ?", whereArgs: [task.chainId]);
  }

  @override
  Future<int> getTotalCount() async {
    var totalCount =
    await task.web3.client.call(
        contract: task.externMasterContract,
        function: task.externMasterContract
            .function('tokenOfListLength'),
        params: [EthereumAddress.fromHex(task.address)]);
    return (totalCount[0] as BigInt).toInt();
  }

  @override
  Future<List> getUnParsedAddressList(List<BigInt> chainIndexList) async {
    // 获取地址数组
    var list = await task.web3.client.call(
        contract: task.externMasterContract,
        function: task.externMasterContract.function('tokenOfList'),
        params: [EthereumAddress.fromHex(task.address), chainIndexList]);
    return list[0];
  }

  @override
  Future<List<BigInt>> getUnParsedChainIndexList() async {
    var list = await Airdrops().get(where: "chain_id = ? and is_parsed = 0", whereArgs: [task.chainId],orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  @override
  Future<void> insertNewToDatabase(int totalCount, int startIndex) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(Airdrops().tableName,Airdrops().fromMap({"chain_id":task.chainId,"chain_index":a}).toMap());
      }
      await batch.commit();
    }
  }

  @override
  bool isParsed(Map params) {
    return params['owner'] != "" &&
        params['invite_address'] != "" &&
        params['token_address'] != "" &&
        params['contract_address'] != "";
  }

  int stringToInt(String str) {
    try {
      var i = int.parse(str);
      return i;
    }catch (e) {
      return 0;
    }
  }
}