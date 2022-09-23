import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/services/Web3Service.dart';
import 'package:ethan_admin/views/components/PullChainData.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:web3dart/credentials.dart';

class Tokens extends Model {
  @override
  final int? id;
  final int chainId;
  final int chainIndex;
  final String owner;
  final String tokenAddress;
  final int type;
  final String name;
  final String symbol;
  final int decimals;
  final String totalSupply;
  final String logo;
  final String inviteAddress;
  final int enableBot;
  final int isKyc;
  final int isAudit;
  final int isParsed;
  int? createdAt;
  int? updatedAt;
  static String tableName = 'tokens';

  Tokens({
    required this.owner,
    required this.chainId,
    required this.tokenAddress,
    required this.type,
    this.id = null,
    this.chainIndex = 0,
    this.name = "",
    this.symbol = "",
    this.decimals = 18,
    this.totalSupply = "0",
    this.logo = "",
    this.inviteAddress = "",
    this.enableBot = -1,
    this.isKyc = 0,
    this.isAudit = 0,
    this.isParsed = 0,
    createdAt,
    updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      "owner": owner,
      "chain_id": chainId,
      "chain_index": chainIndex,
      "token_address": tokenAddress,
      "type": type,
      "name": name,
      "symbol": symbol,
      "decimals": decimals,
      "total_supply": totalSupply,
      "logo": logo,
      "invite_address": inviteAddress,
      "enable_bot": enableBot,
      "is_kyc": isKyc,
      "is_audit": isAudit,
      "is_parsed": isParsed,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
    if (id != null && id as int > 0) {
      map["id"] = id;
    }
    return map;
  }

  Future<Tokens> save() async {
    if (id == null || id as int <= 0) {
      id = await Model.dbService.db.insert(tableName, toMap());
    } else {
      if (await exists()) {
        await Model.dbService.db
            .update(tableName, toMap(), where: 'id = ?', whereArgs: [id]);
      }
    }
    return this;
  }

  Future<int> delete() async {
    if (id != null && id as int > 0) {
      if (await exists()) {
        return await Model.dbService.db
            .delete(tableName, where: 'id = ?', whereArgs: [id]);
      }
    }
    return 0;
  }

  Future<bool> exists() async {
    if (id != null && id as int > 0) {
      var data = await find(id as int);
      var w = fromMap(data);
      if (w.id != null && w.id as int > 0) {
        return true;
      }
    }
    return false;
  }

  static Future<Map<String, Object?>> find(int id) async {
    List<Map<String, Object?>> results = await Model.dbService.db
        .query(tableName, where: 'id = ?', whereArgs: [id]);
    return results.first;
  }

  static Future<List<Map>> all() async {
    var results = <Map>[];
    List<Map> rows = await Model.dbService.db.query(tableName);
    if (rows.isNotEmpty) {
      return rows;
    }
    return results;
  }

  static Future<List<Map>> get(
      {String? where,
      List<Object?>? whereArgs,
      int? limit,
      int? offset,
      String? orderBy}) async {
    var results = <Map>[];
    List<Map> rows = await Model.dbService.db.query(tableName,
        where: where,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset,
        orderBy: orderBy);
    if (rows.isNotEmpty) {
      return rows;
    }
    return results;
  }

  static Future<Map> first({String? where, List<Object?>? whereArgs, String orderBy = 'id desc'}) async {
    List<Map> rows = await get(
        where: where, whereArgs: whereArgs, limit: 1, orderBy: orderBy);
    if (rows.isNotEmpty) {
      return Map.of(rows.first);
    }
    return Tokens.fromMap({}).toMap();
  }

  static Future<int> count({String? where, List<Object?>? whereArgs}) async {
    var rows = await Model.dbService.db.query(tableName,
        where: where, whereArgs: whereArgs, columns: ['count(*) as total']);
    if (rows.isNotEmpty) {
      return rows.first['total'] as int;
    }
    return 0;
  }

  //插入需要更新的索引，返回总数量
  static Future<int> needInsertIndex(ChainOrigin co,PullTask tk) async {
    // 已存在的数量
    var existsCount = await Tokens.count(where: "chain_id = ?",whereArgs: [co.chainId]);
    // 总数量
    var totalCount =
    await co.client.call(
        contract: tk.externMasterContract!,
        function: tk.externMasterContract!
            .function('tokenOfListLength'),
        params: [EthereumAddress.fromHex(tk.address)]);
    var totalInt = (totalCount[0] as BigInt).toInt();
    // 需要解析的数量 = 总数量 - 已存在的数量
    int total = totalInt - existsCount;
    if (total > 0) {
      // 需要解析的索引 = 总数量 - 需要解析的数量
      int startIndex = totalInt - total;
      // 批量插入
      var batch = Model.dbService.db.batch();
      for (int a = startIndex; a < total; a++) {
        batch.insert(Tokens.tableName,{"chain_id":co.chainId,"chain_index":a,"owner":"","enable_bot": -1,"is_parsed": 0,"decimals": 0,"total_supply":"0"});
      }
      await batch.commit();
    }
    return totalInt;
  }

  static Tokens fromMap(Map first) {
    return Tokens(
      id: first["id"] ?? null,
      owner: first["owner"] ?? "",
      chainId: first["chain_id"] ?? 0,
      chainIndex: first["chain_index"] ?? 0,
      tokenAddress: first["token_address"] ?? "",
      type: first["type"] ?? 0,
      name: first["name"] ?? "",
      symbol: first["symbol"] ?? "",
      decimals: first["decimals"] ?? 18,
      totalSupply: first["total_supply"] ?? "0",
      logo: first["logo"] ?? "",
      inviteAddress: first["invite_address"] ?? "",
      enableBot: first["enable_bot"] ?? -1,
      isKyc: first["is_kyc"] ?? 0,
      isAudit: first["is_audit"] ?? 0,
      isParsed: first["is_parsed"] ?? 0,
      createdAt: first["created_at"] ?? null,
      updatedAt: first["updated_at"] ?? null,
    );
  }
}
