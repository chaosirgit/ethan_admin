import 'package:ethan_admin/factories/ExecuteTaskFactory.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Launchpads.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:web3dart/credentials.dart';

class LaunchpadMasterExecute implements ExecuteTaskFactory {
  @override
  Task task;
  bool _lock = false;
  LaunchpadMasterExecute(Task this.task);
  @override
  Future<double> execute(int seconds) async {
    var totalCount = await getTotalCount();
    var startIndex = await getStartIndex();
    await insertNewToDatabase(totalCount, startIndex);
    var indexArr = await getUnParsedChainIndexList();
    var addressArr = await getUnParsedAddressList(indexArr);
    if (addressArr.isNotEmpty) {
      for (var i = 0; i < addressArr.length; i++) {
        // 是否 Kyc Audit
        task.web3.client.call(
          contract: task.externMasterContract,
          function: task.externMasterContract.function('tokenOfParams256'),
          params: [
            addressArr[i],
            [BigInt.from(100), BigInt.from(101)],
          ],
        ).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var launchpad = await Launchpads().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [task.chainId, indexArr[i].toInt()]);
              if (launchpad['is_parsed'] != 1) {
                launchpad["is_kyc"] = (res[0][0] as BigInt).toInt();
                launchpad["is_audit"] = (res[0][1] as BigInt).toInt();
                // kyc == -1
                if (isParsed(launchpad)) {
                  launchpad["is_parsed"] = 1;
                }
                if (launchpad["id"] as int > 0) {
                  var a = await Launchpads().fromMap(launchpad);
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

        //owner
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
          if (!_lock) {
            try {
              _lock = true;
              var launchpad = await Launchpads().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [task.chainId, indexArr[i].toInt()]);
              if (launchpad['is_parsed'] != 1) {
                launchpad["owner"] = res[0].toString();

                // kyc == -1 && owner != ""
                if (isParsed(launchpad)) {
                  launchpad["is_parsed"] = 1;
                }
                if (launchpad["id"] as int > 0) {
                  var a = await Launchpads().fromMap(launchpad);
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
        var launchpadContract = await getContract('Launchpad.abi', addressArr[i].toString());
        var helperAddress = await task.web3.client.call(contract: launchpadContract, function: launchpadContract.function('creator'), params: []);
        var helperContract = await getContract('HelperMaster.abi', helperAddress[1].toString());

        //基础信息 + invite_address
        task.web3.client.call(
            contract: helperContract,
            function: helperContract.function('getBase'),
            params: [addressArr[i]]).then((res) async {
          task.web3.client.call(
              contract: task.referralMasterContract,
              function: task.referralMasterContract.function('referralOf'),
              params: [
                res[0],
              ]).then((r) async {
            if (!_lock) {
              try {
                _lock = true;
                var presaleToken = await task.web3.client.call(
                    contract: task.externMasterContract, 
                    function: task.externMasterContract.function('getTokenBase'),
                    params: [res[1],[BigInt.from(0)],[BigInt.from(0)]]);
                var payToken = await task.web3.client.call(
                    contract: task.externMasterContract,
                    function: task.externMasterContract.function('getTokenBase'),
                    params: [res[2],[BigInt.from(0)],[BigInt.from(0)]]);
                var launchpad = await Launchpads().first(
                    where: "chain_id = ? and chain_index = ?",
                    whereArgs: [
                      task.chainId,
                      indexArr[i].toInt(),
                    ]);
                if (launchpad["is_parsed"] != 1) {
                  launchpad["publisher"] = res[0].toString();
                  launchpad["presale_address"] = res[1].toString();
                  launchpad["pay_address"] = res[2].toString();
                  launchpad["router_address"] = res[3].toString();
                  launchpad["invite_address"] = r[0].toString();
                  launchpad["presale_name"] = presaleToken[0];
                  launchpad["presale_symbol"] = presaleToken[1];
                  launchpad["presale_decimals"] = (presaleToken[2] as BigInt).toInt();
                  launchpad["pay_name"] = payToken[0];
                  launchpad["pay_symbol"] = payToken[1];
                  launchpad["pay_decimals"] = (payToken[2] as BigInt).toInt();

                  if (isParsed(launchpad)) {
                    launchpad["is_parsed"] = 1;
                  }
                  if (launchpad['id'] as int > 0) {
                    var a = await Launchpads().fromMap(launchpad);
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

        //基础参数
        task.web3.client.call(
            contract: helperContract,
            function: helperContract.function('getParams'),
            params: [
              addressArr[i],
            ]).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var launchpad = await Launchpads().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (launchpad["is_parsed"] != 1) {
                launchpad["begin_at"] = (res[0][0] as BigInt).toInt();
                launchpad["end_at"] = (res[0][1] as BigInt).toInt();
                launchpad['soft_cap'] = (res[0][2] as BigInt).toString();
                launchpad['hard_cap'] = (res[0][3] as BigInt).toString();
                launchpad['min_purchase'] = (res[0][4] as BigInt).toString();
                launchpad['max_purchase'] = (res[0][5] as BigInt).toString();
                launchpad['type'] = (res[0][6] as BigInt).toInt();
                launchpad['rate'] = (res[1][0] as BigInt).toInt();
                launchpad['price'] = (res[1][1] as BigInt).toString();
                launchpad['token_fee'] = (res[1][2] as BigInt).toInt();
                launchpad['pay_fee'] = (res[1][3] as BigInt).toInt();
                launchpad['rewards_token_type'] = (res[1][4] as BigInt).toInt();
                launchpad['first_level'] = (res[1][5] as BigInt).toInt();
                launchpad['second_level'] = (res[1][6] as BigInt).toInt();
                launchpad['referral_buy'] = (res[1][7] as BigInt).toInt();
                launchpad['sale_type'] = (res[1][8] as BigInt).toInt();
                launchpad['change_public'] = (res[1][9] as BigInt).toInt();
                launchpad['undone_process'] = (res[1][10] as BigInt).toInt();
                launchpad['liquidity_rate'] = (res[1][11] as BigInt).toInt();
                launchpad['liquidity_lock_time'] =
                    (res[1][12] as BigInt).toInt();
                launchpad['first_unlock_rate'] = (res[1][13] as BigInt).toInt();
                launchpad['next_unlock_rate'] = (res[1][14] as BigInt).toInt();
                launchpad['unlock_cycle_time'] = (res[1][15] as BigInt).toInt();
                if (isParsed(launchpad)) {
                  launchpad["is_parsed"] = 1;
                }
                if (launchpad["id"] as int > 0) {
                  var a = await Launchpads().fromMap(launchpad);
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
                BigInt.from(10)
              ]
            ]).then((res) async {
          if (!_lock) {
            try {
              _lock = true;
              var launchpad = await Launchpads().first(
                  where: "chain_id = ? and chain_index = ?",
                  whereArgs: [
                    task.chainId,
                    indexArr[i].toInt(),
                  ]);
              if (launchpad["is_parsed"] != 1) {
                launchpad['contract_address'] = addressArr[i].toString();
                launchpad["logo"] = res[0][0];
                launchpad["website"] = res[0][1];
                launchpad["twitter"] = res[0][2];
                launchpad["telegram"] = res[0][3];
                launchpad["discord"] = res[0][4];
                launchpad["facebook"] = res[0][5];
                launchpad["github"] = res[0][6];
                launchpad["instagram"] = res[0][7];
                launchpad["reddit"] = res[0][8];
                launchpad["description"] = res[0][9];
                // launchpad["pay_symbol"] = res[0][10];

                if (isParsed(launchpad)) {
                  launchpad["is_parsed"] = 1;
                }
                if (launchpad['id'] as int > 0) {
                  var a = await Launchpads().fromMap(launchpad);
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
    var parsedCount = await Launchpads().count(
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
    return await Launchpads().count(where: "chain_id = ?", whereArgs: [task.chainId]);
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
    var list = await Launchpads().get(where: "chain_id = ? and is_parsed = 0", whereArgs: [task.chainId],orderBy: "chain_index asc");
    return list.map((e) => BigInt.parse(e['chain_index'].toString())).toList();
  }

  @override
  Future<void> insertNewToDatabase(int totalCount, int startIndex) async {
    if (totalCount > 0 && (totalCount - startIndex) > 0) {
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < totalCount; a++) {
        batch.insert(Launchpads().tableName,Launchpads().fromMap({"chain_id":task.chainId,"chain_index":a}).toMap());
      }
      await batch.commit();
    }
  }

  @override
  bool isParsed(Map params) {
    return params['is_kyc'] as int > -1 &&
        params['owner'] != "" &&
        params['invite_address'] != "" &&
        params['begin_at'] as int > 0 &&
        params['contract_address'] != "";
  }

}